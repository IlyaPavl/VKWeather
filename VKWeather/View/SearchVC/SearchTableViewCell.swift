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
        setupText(label: cityNameLabel, text: nil, textColor: .systemGray, fontSize: 16, fontWeight: .regular)
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            cityNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cityNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cityNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
