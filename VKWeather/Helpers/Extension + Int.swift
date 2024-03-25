//
//  Extension + Int.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import Foundation

extension Int {
    func toDateFormatted(withDayOfWeek: Bool = false) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        if withDayOfWeek {
            dateFormatter.dateFormat = "EE"
        } else {
            dateFormatter.dateFormat = "dd.MM"
        }
        
        return dateFormatter.string(from: date)
    }
}
