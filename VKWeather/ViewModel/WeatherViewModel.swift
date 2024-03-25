//
//  WeatherViewModel.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import Foundation
import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
    func weatherDataDidUpdate()
    func didFailToReceiveWeatherData()
}

class WeatherViewModel: NSObject {
    typealias AuthorizationStatusHandler = (CLAuthorizationStatus) -> Void
    
    private let networkManager = NetworkWeatherManager.shared
    weak var delegate: WeatherViewModelDelegate?
    private var locationManager = CLLocationManager()
    var authorizationStatusHandler: AuthorizationStatusHandler?
    
    var currentWeather: WeatherModel?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestWeatherForCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchWeatherData(for requestType: RequestType) {
        switch requestType {
        case .cityName(let city):
            networkManager.fetchCurrentWeather(forRequestType: .cityName(city: city)) { [weak self] result in
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                    self?.delegate?.weatherDataDidUpdate()
                case .failure(_):
                    self?.delegate?.didFailToReceiveWeatherData()
                    print("fetchWeatherData Error for cityName")
                }
            }
        case .coordinate(let latitude, let longitude):
            networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude)) { [weak self] result in
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                    self?.delegate?.weatherDataDidUpdate()
                case .failure(_):
                    self?.delegate?.didFailToReceiveWeatherData()
                    print("fetchWeatherData Error for coordinate")
                }
            }
        }
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        fetchWeatherData(for: .coordinate(latitude: latitude, longitude: longitude))
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        print("If you are using Xcode simulator - choose location in up menu Features -> Location -> ")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location services authorization denied or restricted.")
        case .notDetermined:
            print("Location services authorization not determined.")
        case .authorizedAlways:
            print("Location services authorized always.")
        @unknown default:
            fatalError("Unhandled CLLocationManager authorization status case.")
        }
        authorizationStatusHandler?(status)
    }
}

