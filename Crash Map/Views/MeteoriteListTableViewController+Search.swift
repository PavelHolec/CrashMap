import Foundation
import UIKit

extension MeteoriteListTableViewController: UISearchResultsUpdating {
    
    var isSearchBarEmpty: Bool {
        navigationItem.searchController!.searchBar.text?.isEmpty ?? true
    }
    
    func addSearchController() {
        assert(navigationItem.searchController == nil, "Search Controller is already added")
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Meteorite..."
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setBaseFilter(toYear year: Int) {
        let yearToken = UISearchToken(icon: UIImage(systemName: "calendar"), text: "Since \(year)")
        navigationItem.searchController?.searchBar.searchTextField.insertToken(yearToken, at: 0)
        navigationItem.searchController?.searchBar.searchTextField.allowsCopyingTokens = false
        navigationItem.searchController?.searchBar.searchTextField.allowsDeletingTokens = false
        navigationItem.searchController?.searchBar.searchTextField.clearButtonMode = .never
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else {
            return
        }
        
        let filteredMeteorites = allMeteorites.filter({
            $0.name.localizedCaseInsensitiveContains(searchTerm) ||
            $0.class.localizedCaseInsensitiveContains(searchTerm) ||
            $0.yearTitle.localizedCaseInsensitiveContains(searchTerm) ||
            $0.idTitle.localizedCaseInsensitiveContains(searchTerm)
        })
        
        setFilteredMeteoritesTo(filteredMeteorites)
        tableView.reloadData()
    }
}

extension MeteoriteListTableViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        setBaseFilter(toYear: filterSinceYear)
    }
}
