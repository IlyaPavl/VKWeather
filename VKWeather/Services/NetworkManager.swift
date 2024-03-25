//
//  NetworkManager.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import Foundation
import CoreLocation

final class NetworkWeatherManager: NetworkServiceProtocol {
    
    static let shared = NetworkWeatherManager()
    private init() {}
    
    private func getData<T: Decodable>(from url: URL, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.noData))
                return
            }
            DispatchQueue.main.async {
                do {
                    let decodedData = try JSONDecoder().decode(modelType, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(APIError.decodingError))
                }
            }
        }.resume()
    }
    
    func fetchCurrentWeather(forRequestType requestType: RequestType, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            if let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?q=\(encodedCity)&units=metric&cnt=\(daysForecast)&appid=\(apiKey)"
            }
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&units=metric&cnt=\(daysForecast)&appid=\(apiKey)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.wrongURL))
            return
        }
        getData(from: url, modelType: WeatherModel.self, completion: completion)
    }
}
