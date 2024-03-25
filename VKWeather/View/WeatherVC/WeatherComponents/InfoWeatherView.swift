//
//  InfoWeatherView.swift
//  VKWeather
//
//  Created by ily.pavlov on 23.03.2024.
//

import UIKit

final class InfoWeatherView: UIView {
    private let mainStack = UIStackView()
    private let feelsLikeStack = UIStackView()
    private let humidityStack = UIStackView()
    private let windStack = UIStackView()
    private let feelsLikeText = UILabel()
    private let feelsLikeLabel = UILabel()
    private let humidityText = UILabel()
    private let humidityLabel = UILabel()
    private let windText = UILabel()
    private let windLabel = UILabel()
    private let textFontSize: CGFloat = 14
    private let labelFontSize: CGFloat = 24
    private let defaultStackHeight: CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInfoUI()
        setupInfoConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDataFor(feelsLike: String, humidity: String, wind: String) {
        self.feelsLikeLabel.text = feelsLike
        self.humidityLabel.text = humidity
        self.windLabel.text = wind
    }
}
//MARK: - setupInfoUI
extension InfoWeatherView {
    private func setupInfoUI() {
        setupStack(stack: mainStack, axis: .horizontal, alignment: .center, spacing: spacing, distribution: .fillEqually, cornerRadius: cornerRadius)
        setupStack(stack: feelsLikeStack, axis: .vertical, alignment: .center, spacing: spacing, distribution: .fillProportionally, cornerRadius: cornerRadius)
        setupText(label: feelsLikeText, text: "Feels like", textColor: .white, fontSize: textFontSize, fontWeight: .semibold)
        setupText(label: feelsLikeLabel, text: nil, textColor: .white, fontSize: labelFontSize, fontWeight: .black)
        setupStack(stack: humidityStack, axis: .vertical, alignment: .center, spacing: spacing, distribution: .fillProportionally, cornerRadius: cornerRadius)
        setupText(label: humidityText, text: "Cloudness", textColor: .white, fontSize: textFontSize, fontWeight: .semibold)
        setupText(label: humidityLabel, text: nil, textColor: .white, fontSize: labelFontSize, fontWeight: .black)
        setupStack(stack: windStack, axis: .vertical, alignment: .center, spacing: spacing, distribution: .fillProportionally, cornerRadius: cornerRadius)
        setupText(label: windText, text: "Wind Speed", textColor: .white, fontSize: textFontSize, fontWeight: .semibold)
        setupText(label: windLabel, text: nil, textColor: .white, fontSize: labelFontSize, fontWeight: .black)
        
        feelsLikeStack.backgroundColor = mainBGColor
        humidityStack.backgroundColor = mainBGColor
        windStack.backgroundColor = mainBGColor

        feelsLikeStack.addArrangedSubview(feelsLikeText)
        feelsLikeStack.addArrangedSubview(feelsLikeLabel)
        humidityStack.addArrangedSubview(humidityText)
        humidityStack.addArrangedSubview(humidityLabel)
        windStack.addArrangedSubview(windText)
        windStack.addArrangedSubview(windLabel)
        mainStack.addArrangedSubview(feelsLikeStack)
        mainStack.addArrangedSubview(humidityStack)
        mainStack.addArrangedSubview(windStack)
        addSubview(mainStack)
    }
    
    private func setupInfoConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        feelsLikeStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feelsLikeStack.heightAnchor.constraint(equalToConstant: defaultStackHeight)
        ])
        
        humidityStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            humidityStack.heightAnchor.constraint(equalToConstant: defaultStackHeight)
        ])
        
        windStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            windStack.heightAnchor.constraint(equalToConstant: defaultStackHeight)
        ])
    }
}
