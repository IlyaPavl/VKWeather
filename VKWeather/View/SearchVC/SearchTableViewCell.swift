//
//  SearchTableViewCell.swift
//  VKWeather
//
//  Created by ily.pavlov on 24.03.2024.
//

import UIKit
import MapKit

final class SearchResultTableViewCell: UITableViewCell {
    static let searchCellIdentifier = "searchCellIdentifier"
    private var cityNameLabel = UILabel()
    private let cityNameTextSize: CGFloat = 16
    private let cityNameLabelOffset: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSearchCellUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with searchResult: MKLocalSearchCompletion) {
        cityNameLabel.text = searchResult.title
    }
}

//MARK: - setupSearchCellUI
extension SearchResultTableViewCell {
    private func setupSearchCellUI() {
        addSubview(cityNameLabel)
        setupText(label: cityNameLabel, text: nil, textColor: .systemGray, fontSize: cityNameTextSize, fontWeight: .regular)
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: cityNameLabelOffset / 2),
            cityNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: cityNameLabelOffset),
            cityNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -cityNameLabelOffset),
            cityNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -cityNameLabelOffset / 2)
        ])
    }
}
