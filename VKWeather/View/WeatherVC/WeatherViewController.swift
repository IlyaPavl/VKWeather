//
//  WeatherViewController.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    private var viewModel = WeatherViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let currentWeatherView = CurrentWeatherView()
    private let infoWeatherView = InfoWeatherView()
    private let forecastTableView = ForecastTableView()
    
    private let backgroundOpacity: Float = 0.9
    private let defaultForecastTableViewHeight: CGFloat = 327
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBG()
        setUpToolbar()
        setupMainUI()
        
        viewModel.addObserver(self)
        viewModel.requestLocationAuthorization()
        viewModel.authorizationStatusHandler = { [weak self] status in
            self?.showAlertForAuthorizationStatus(status)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width, height: currentWeatherView.frame.height + infoWeatherView.frame.height + forecastTableView.frame.height + 100)
    }
    
    deinit {
        viewModel.removeObserver(self)
    }
}

//MARK: - SearchCityViewControllerDelegate
extension WeatherViewController: SearchCityViewControllerDelegate {
    func didCitySelected(cityName: String) {
        let city = cityName.split(separator: " ").joined(separator: "%20")
        viewModel.fetchWeatherData(for: .cityName(city: city))
    }
}


//MARK: - WeatherViewModelDelegate
extension WeatherViewController: WeatherUpdateObserver {
    func didUpdateWeatherData() {
        // Обработка обновления данных о погоде
        if let weather = viewModel.currentWeather {
            currentWeatherView.setupDataFor(cityLabel: weather.city.name, tempLabel: "\(Int(weather.list[0].temp.day))°", conditionCode: weather.list[0].weather[0].id)
            infoWeatherView.setupDataFor(feelsLike: "\(Int(weather.list[0].feelsLike.day))°", humidity: "\(Int(weather.list[0].clouds)) %", wind: "\(Int(weather.list[0].speed)) m/s")
            forecastTableView.forecasts = weather.list
            forecastTableView.reloadData()
        }
    }
    
    func didFailToReceiveWeatherData() {
        // Обработка неудачного получения данных о погоде
        let alertController = UIAlertController(title: "City not found", message: "Entered city wasn't found. Try again and make sure that city presents or supported by OpenWeather API", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: - SetupUI
extension WeatherViewController {
    private func setupBG() {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.opacity = backgroundOpacity
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    private func setUpToolbar() {
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = mainBGColor
        navigationController?.toolbar.tintColor = .white
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.scrollEdgeAppearance = appearance
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let myGeoButton = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: .plain, target: self, action: #selector(myGeoButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [flexibleSpace, myGeoButton, flexibleSpace, searchButton]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc private func searchButtonTapped() {
        let searchCityViewController = SearchCityViewController()
        searchCityViewController.cityDelegate = self
        present(searchCityViewController, animated: true, completion: nil)
    }
    
    @objc private func myGeoButtonTapped() {
        viewModel.requestWeatherForCurrentLocation()
    }
    
    private func setupMainUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.autoresizingMask = [.flexibleHeight]
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(currentWeatherView)
        contentView.addSubview(infoWeatherView)
        contentView.addSubview(forecastTableView)
        
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        infoWeatherView.translatesAutoresizingMaskIntoConstraints = false
        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWeatherView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: commonOffset),
            currentWeatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -commonOffset),
            
            infoWeatherView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: commonOffset),
            infoWeatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: commonOffset),
            infoWeatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -commonOffset),
            
            forecastTableView.topAnchor.constraint(equalTo: infoWeatherView.bottomAnchor, constant: commonOffset),
            forecastTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: commonOffset),
            forecastTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -commonOffset),
            forecastTableView.heightAnchor.constraint(equalToConstant: defaultForecastTableViewHeight),
        ])
        
        currentWeatherView.backgroundColor = mainBGColor
        currentWeatherView.layer.cornerRadius = cornerRadius + 5
        forecastTableView.layer.cornerRadius = cornerRadius
        forecastTableView.backgroundColor = mainBGColor
    }
    
    private func showAlertForAuthorizationStatus(_ status: CLAuthorizationStatus) {
        let alertController: UIAlertController
        
        switch status {
        case .authorizedWhenInUse:
            return
        case .denied:
            alertController = UIAlertController(title: "Location Access Denied", message: "Please enable location access in Settings to properly show weather", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        case .restricted:
            alertController = UIAlertController(title: "Location Access Restricted", message: "Location access is restricted on this device", preferredStyle: .alert)
        case .notDetermined:
            alertController = UIAlertController(title: "Location Access Not Determined", message: "Location access has not been determined yet", preferredStyle: .alert)
        case .authorizedAlways:
            return
        @unknown default:
            fatalError("Unhandled CLAuthorizationStatus case.")
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
