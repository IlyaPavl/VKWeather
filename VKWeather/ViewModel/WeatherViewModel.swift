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
    weak var delegate: WeatherViewModelDelegate?
    var authorizationStatusHandler: AuthorizationStatusHandler?
    var currentWeather: WeatherModel?
    private let networkManager = NetworkWeatherManager.shared
    private let locationManager = LocationManager()
    private let userDefaults = UserDefaults.standard
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestWeatherForCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func requestLocationAuthorization() {
        locationManager.requestAuthorization()
    }
    
    func fetchWeatherData(for requestType: RequestType) {
        if let cachedWeather = getCachedWeatherData(forRequestType: requestType) {
            self.currentWeather = cachedWeather
            self.delegate?.weatherDataDidUpdate()
            print(cachedWeather)
            return
        }
        
        switch requestType {
        case .cityName(let city):
            networkManager.fetchCurrentWeather(forRequestType: .cityName(city: city)) { [weak self] result in
                switch result {
                case .success(let weather):
                    self?.cacheWeatherData(weather, forRequestType: requestType)
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
                    self?.cacheWeatherData(weather, forRequestType: requestType)
                    self?.currentWeather = weather
                    self?.delegate?.weatherDataDidUpdate()
                case .failure(_):
                    self?.delegate?.didFailToReceiveWeatherData()
                    print("fetchWeatherData Error for coordinate")
                }
            }
        }
    }
    
    private func cacheWeatherData(_ weather: WeatherModel, forRequestType requestType: RequestType) {
        if let encoded = try? JSONEncoder().encode(weather) {
            userDefaults.set(encoded, forKey: requestType.cacheKey)
        }
    }
    
    private func getCachedWeatherData(forRequestType requestType: RequestType) -> WeatherModel? {
        if let savedData = userDefaults.data(forKey: requestType.cacheKey),
           let decoded = try? JSONDecoder().decode(WeatherModel.self, from: savedData) {
            return decoded
        }
        return nil
    }
}

// MARK: - LocationManagerDelegate
extension WeatherViewModel: LocationManagerDelegate {
    func didUpdateLocation(latitude: Double, longitude: Double) {
        fetchWeatherData(for: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
        print("If you are using Xcode simulator - choose location in top menu Features -> Location -> ")
    }
    
    func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
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
