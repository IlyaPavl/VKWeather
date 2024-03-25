//
//  NetworkServiceProtocol.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import Foundation
protocol NetworkServiceProtocol: AnyObject {
    func fetchCurrentWeather(forRequestType requestType: RequestType, completion: @escaping (Result<WeatherModel, Error>) -> Void)
}
