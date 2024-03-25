//
//  APIErrors.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import Foundation

enum APIError: Error {
    case decodingError
    case noData
    case wrongURL
    
    var title: String {
        switch self {
        case .decodingError:
            return "Can't decode received data"
        case .noData:
            return "Can't fetch data"
        case .wrongURL:
            return "Wrong URL"
        }
    }
}
