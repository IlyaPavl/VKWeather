//
//  SearchCityViewController.swift
//  VKWeather
//
//  Created by ily.pavlov on 24.03.2024.
//

import UIKit
import MapKit

protocol SearchCityViewControllerDelegate: AnyObject {
    func didCitySelected(cityName: String)
}

final class SearchCityViewController: UIViewController {
    
    weak var cityDelegate: SearchCityViewControllerDelegate?
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchTableView = SearchResultsTableView()
    private var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchUI()
        searchCompleter.delegate = self
        searchTableView.searchDelegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        searchBar.becomeFirstResponder()
    }
}

//MARK: - SearchResultsTableViewDelegate
extension SearchCityViewController: SearchResultsTableViewDelegate {
    func didSelectSearchResult(_ result: String) {
        cityDelegate?.didCitySelected(cityName: result)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UISearchBarDelegate
extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension SearchCityViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchTableView.searchResults = completer.results
        searchTableView.reloadData()
    }
}

//MARK: - setupSearchUI
extension SearchCityViewController {
    private func setupSearchUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Enter city name"
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
