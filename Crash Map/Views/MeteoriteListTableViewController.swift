import Foundation
import UIKit

class MeteoriteListTableViewController: UITableViewController {
    
    let meteoriteService = MeteoriteService()
    
    var filteredMeteorites: [Meteorite] = []
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchController()
    }
    
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredMeteorites.count : meteoriteService.meteorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meteoriteCell = tableView.dequeueReusableCell(withIdentifier: "Meteorite Cell") as! MeteoriteListTableViewCell
        let meteorite = isFiltering ? filteredMeteorites[indexPath.row] : meteoriteService.meteorites[indexPath.row]
        meteoriteCell.configure(meteorite: meteorite)
        return meteoriteCell
    }
    
    @IBSegueAction
    func makeMeteoriteDetailViewController(coder: NSCoder) -> UIViewController? {
        let selectedMeteorite = meteoriteService.getMeteorite(index: tableView!.indexPathForSelectedRow!.row)
        return MeteoriteDetailViewController(coder: coder, meteorite: selectedMeteorite)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Private
    private func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Meteorite..."
        
        navigationItem.searchController = searchController
    }
}

// MARK: - Search
extension MeteoriteListTableViewController: UISearchResultsUpdating {
    
    var isSearchBarEmpty: Bool {
        navigationItem.searchController!.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        navigationItem.searchController!.isActive && !isSearchBarEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else {
            return
        }
        
        tableView.reloadData()
    }
}
