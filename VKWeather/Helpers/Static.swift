//
//  Constants.swift
//  VKWeather
//
//  Created by ily.pavlov on 22.03.2024.
//

import Foundation
import UIKit

let apiKey = "98ba4333281c6d0711ca78d2d0481c3d"
let daysForecast = 7

let cornerRadius: CGFloat = 15
let spacing: CGFloat = 5
let mainBGColor = UIColor.black.withAlphaComponent(0.03)

func setupStack(stack: UIStackView, axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, spacing: CGFloat, distribution: UIStackView.Distribution?, cornerRadius: CGFloat) {
    stack.axis = axis
    stack.alignment = alignment
    stack.spacing = spacing
    stack.layer.cornerRadius = cornerRadius
    if let distribution = distribution {
        stack.distribution = distribution
    }
}

func setupText(label: UILabel, text: String?, textColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight) {
    label.text = text
    label.textColor = textColor
    label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
}

func systemIconNameString(for conditionCode: Int) -> String {
    switch conditionCode {
    case 200...232: return "cloud.bolt.rain.fill"
    case 300...321: return "cloud.drizzle.fill"
    case 500...531: return "cloud.rain.fill"
    case 600...622: return "cloud.snow.fill"
    case 701...781: return "smoke.fill"
    case 800: return "sun.min.fill"
    case 801...804: return "cloud.fill"
    default: return "nosign"
    }
}

func addBlurEffect(to view: UIView) {
    let blurEffect = UIBlurEffect(style: .extraLight)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false
    blurEffectView.clipsToBounds = true
    blurEffectView.layer.cornerRadius = cornerRadius
    
    view.insertSubview(blurEffectView, at: 0)
    
    NSLayoutConstraint.activate([
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
}
