//
//  WeatherModel.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let city: City
    let cnt: Int
    let list: [List]
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let weather: [Weather]
    let speed: Double
    let clouds: Int

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity, weather, speed, clouds
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description: String
}
