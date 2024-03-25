//
//  SearchResultsTableView.swift
//  VKWeather
//
//  Created by ily.pavlov on 24.03.2024.
//

import UIKit
import MapKit

protocol SearchResultsTableViewDelegate: AnyObject {
    func didSelectSearchResult(_ result: String)
}

final class SearchResultsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var searchResults: [MKLocalSearchCompletion] = []
    weak var searchDelegate: SearchResultsTableViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.searchCellIdentifier)
        setupTableUI()
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableUI() {
        self.separatorColor = .systemGray4
        self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: SearchResultTableViewCell.searchCellIdentifier, for: indexPath) as! SearchResultTableViewCell
        cell.configure(with: searchResults[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        searchDelegate?.didSelectSearchResult(selectedResult.title)
        deselectRow(at: indexPath, animated: true)
    }
}
