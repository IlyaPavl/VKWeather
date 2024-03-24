//
//  SearchViewController.swift
//  VKWeather
//
//  Created by ily.pavlov on 24.03.2024.
//

import UIKit
import MapKit


class SearchCityViewController: UIViewController {
        
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchTableView = SearchResultsTableView()
    private var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchUI()
        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        searchBar.becomeFirstResponder()
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension SearchCityViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let englishResults = completer.results.filter { $0.title.rangeOfCharacter(from: .letters) != nil }
        searchTableView.searchResults = englishResults
        searchTableView.reloadData()
    }
}

extension SearchCityViewController {
    private func setupSearchUI() {
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
