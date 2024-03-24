//
//  WeatherViewController.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    private let viewModel = WeatherViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let currentWeatherBlock = CurrentWeatherBlock()
    private let infoweatherBlock = InfoWeatherBlock()
    private let forecastTableBlock = ForecastTableViewController()
    private let defaultCurrentWeatherBlockHeight: CGFloat = 250
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        setupBG()
        setUpToolbar()
        setupUI()
        viewModel.delegate = self
        viewModel.requestLocationAuthorization()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width, height: currentWeatherBlock.frame.height + infoweatherBlock.frame.height + forecastTableBlock.view.frame.height + 200)
    }
}

//MARK: - WeatherViewModelDelegate
extension WeatherViewController: WeatherViewModelDelegate {
    func weatherDataDidUpdate() {
        if let list = viewModel.weatherModel?.list,
           let city = viewModel.weatherModel?.city,
           let conditionCode = viewModel.weatherModel?.list[0].weather[0].id,
           let feelsLike = viewModel.weatherModel?.list[0].feelsLike.day,
           let humidity = viewModel.weatherModel?.list[0].humidity,
           let wind = viewModel.weatherModel?.list[0].speed {
            currentWeatherBlock.setupDataFor(cityLabel: city.name, tempLabel: "\(Int(list[0].temp.day))°", conditionCode: conditionCode)
            infoweatherBlock.setupDataFor(feelsLike: "\(Int(feelsLike))°", humidity: "\(Int(humidity)) %", wind: "\(Int(wind)) m/s")
            forecastTableBlock.forecasts = list
            forecastTableBlock.tableView.reloadData()
        }
    }
}

extension WeatherViewController: SearchCityDelegate {
    func didSearchCity(cityName: String) {
        viewModel.fetchWeatherData(for: .cityName(city: cityName))
    }
    
    
}

//MARK: - SetupUI
extension WeatherViewController {
    private func setupBG() {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.opacity = 0.9
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
        let searchCityViewController = SearchViewController()
        searchCityViewController.delegate = self
        present(searchCityViewController, animated: true, completion: nil)
    }
    
    @objc private func myGeoButtonTapped() {
        viewModel.requestWeatherForCurrentLocation()
    }
    
    private func setupUI() {
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
        
        contentView.addSubview(currentWeatherBlock)
        contentView.addSubview(infoweatherBlock)
        contentView.addSubview(forecastTableBlock.view)
        
        currentWeatherBlock.translatesAutoresizingMaskIntoConstraints = false
        infoweatherBlock.translatesAutoresizingMaskIntoConstraints = false
        forecastTableBlock.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWeatherBlock.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentWeatherBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            currentWeatherBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            //            currentWeatherBlock.heightAnchor.constraint(equalToConstant: defaultCurrentWeatherBlockHeight),
            
            infoweatherBlock.topAnchor.constraint(equalTo: currentWeatherBlock.bottomAnchor, constant: 20),
            infoweatherBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoweatherBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            forecastTableBlock.view.topAnchor.constraint(equalTo: infoweatherBlock.bottomAnchor, constant: 20),
            forecastTableBlock.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            forecastTableBlock.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            forecastTableBlock.view.heightAnchor.constraint(equalToConstant: 327),
        ])
        
        currentWeatherBlock.backgroundColor = mainBGColor
        currentWeatherBlock.layer.cornerRadius = cornerRadius + 5
        forecastTableBlock.view.layer.cornerRadius = cornerRadius
        forecastTableBlock.view.backgroundColor = mainBGColor
    }
}
