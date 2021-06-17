//
//  SearchCitiesViewController.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/6.
//

import UIKit
import MapKit

class SearchCitiesViewController: UIViewController, StoryboardInstantiable, Alertable {

    static let identifier = String(describing: SearchCitiesViewController.self)
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    private var searchResults: [MKLocalSearchCompletion] = [MKLocalSearchCompletion]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var viewModel: SearchCitiesViewModel!
    
    // MARK: Lifecycle
    
    static func create(with viewModel: SearchCitiesViewModel) -> SearchCitiesViewController {
        let view = SearchCitiesViewController.instantiateViewController(withIdentifier: identifier)
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder()
    }
    
    private func setupViewController() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = .address
        searchCompleter.delegate = self
    }

    private func registerNib() {
        tableView.register(UINib(nibName: SearchListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SearchListTableViewCell.reuseIdentifier)
    }

    private func updateSearchResults(selected: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: selected)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error != nil {
                return
            }
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                return
            }

            self.viewModel.didSelect(Coordinate(lat: coordinate.latitude, lon: coordinate.longitude))
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: TableView Delegate and DataSource
extension SearchCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchListTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchListTableViewCell.reuseIdentifier, for: indexPath as IndexPath) as? SearchListTableViewCell else {
            fatalError("SearchListTableViewCell cell is not found")
        }
        cell.fillData(searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateSearchResults(selected: searchResults[indexPath.row])
    }
}

// MARK: SearchBar Delegate
extension SearchCitiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text,
            searchText.count > 0 else {
                searchResults.removeAll()
                return
        }
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
            searchText.count > 0 else {
                return
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: ScrollView Delegate
extension SearchCitiesViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: MKLocalSearchCompleterDelegate
extension SearchCitiesViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
    }
}
