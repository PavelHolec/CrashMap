import Foundation
import UIKit

class MeteoriteListTableViewController: UITableViewController {
    
    private var meteoriteService: MeteoriteService!
    private var filterSinceYear: Int!
    
    private(set) var allMeteorites: [Meteorite] = []
    private var filteredMeteorites: [Meteorite] = []
    
    // MARK: - Configuration
    func configure(meteoriteService: MeteoriteService, filterSinceYear: Int) {
        self.meteoriteService = meteoriteService
        self.filterSinceYear = filterSinceYear
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchController()
        setBaseFilter(toYear: filterSinceYear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        meteoriteService.getMeteorites(sinceYear: filterSinceYear) { result in
            switch result {
            case .failure:
                break
            case .success(let meteorites):
                self.allMeteorites = meteorites
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
        isFiltering ? filteredMeteorites.count : allMeteorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meteoriteCell = tableView.dequeueReusableCell(withIdentifier: "Meteorite Cell") as! MeteoriteListTableViewCell
        let meteorite = isFiltering ? filteredMeteorites[indexPath.row] : allMeteorites[indexPath.row]
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
    
    // MARK: - Segues
    @IBSegueAction
    func makeMeteoriteDetailViewController(coder: NSCoder) -> UIViewController? {
        let selectedMeteorite = allMeteorites[tableView.indexPathForSelectedRow!.row]
        return MeteoriteDetailViewController(coder: coder, meteorite: selectedMeteorite)
    }
    
    // MARK: - Filtering
    func setFilteredMeteoritesTo(_ filteredMeteorites: [Meteorite]) {
        self.filteredMeteorites = filteredMeteorites
    }
}

