import Foundation
import UIKit

class MeteoriteListTableViewController: UITableViewController {
    
    let meteoriteService = MeteoriteService()
    
    var meteorites: [Meteorite] = []
    var filteredMeteorites: [Meteorite] = []
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchController()
        
        meteoriteService.performRequest() { result in
            switch result {
            case .failure:
                break
            case .success(let meteorites):
                self.meteorites = meteorites
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredMeteorites.count : meteorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meteoriteCell = tableView.dequeueReusableCell(withIdentifier: "Meteorite Cell") as! MeteoriteListTableViewCell
        let meteorite = isFiltering ? filteredMeteorites[indexPath.row] : meteorites[indexPath.row]
        meteoriteCell.configure(meteorite: meteorite)
        return meteoriteCell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MeteoriteListTableViewCell
        cell.set(selected: true)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MeteoriteListTableViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.set(selected: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MeteoriteListTableViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.set(selected: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAtIndexPath indexPath: IndexPath) {

    }
    
    @IBSegueAction
    func makeMeteoriteDetailViewController(coder: NSCoder) -> UIViewController? {
        let selectedMeteorite = meteorites[tableView.indexPathForSelectedRow!.row]
        return MeteoriteDetailViewController(coder: coder, meteorite: selectedMeteorite)
    }
    
    // MARK: - Private
    private func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Meteorite..."
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
        
        filteredMeteorites = meteorites.filter({ $0.name.contains(searchTerm)})
        
        tableView.reloadData()
    }
}
