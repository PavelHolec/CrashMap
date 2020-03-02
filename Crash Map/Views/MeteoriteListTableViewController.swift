import Foundation
import UIKit
import MapKit

class MeteoriteListTableViewController: UITableViewController {
    
    private var meteoriteService: MeteoriteService!
    
    private(set) var filterSinceYear: Int!
    private(set) var allMeteorites: [Meteorite] = []
    private(set) var filteredMeteorites: [Meteorite] = []
    
    var isFiltering: Bool {
        navigationItem.searchController!.isActive && !isSearchBarEmpty
    }
    
    var meteorites: [Meteorite] {
        isFiltering ? filteredMeteorites : allMeteorites
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var emptyTableView: UIView!
    @IBOutlet private var tableHeaderView: UIView!
    
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
        enablePullToResfresh()
        
        //navigationController?.navigationBar.largeTitleTextAttributes = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meteorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meteoriteCell = tableView.dequeueReusableCell(withIdentifier: "Meteorite Cell") as! MeteoriteListTableViewCell
        
        guard let meteorite = meteorites[safe: indexPath.row] else {
            return meteoriteCell
        }
        
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let gradientView = tableHeaderView.subviews[1] as! GradientView
        gradientView.startColor = UIColor.systemBackground.withModified(alphaOffset: -1.0)
        return meteorites.count > 0 ? tableHeaderView : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return meteorites.count > 0 ? tableView.bounds.height * 0.3 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return meteorites.count > 0 ? nil : emptyTableView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return meteorites.count > 0 ? 0 : tableView.bounds.height * 0.6
    }
    
    // MARK: - Segues
    @IBSegueAction
    func makeMeteoriteDetailViewController(coder: NSCoder) -> UIViewController? {
        let selectedMeteorite = meteorites[tableView.indexPathForSelectedRow!.row]
        return MeteoriteDetailViewController(coder: coder, meteorite: selectedMeteorite)
    }
    
    // MARK: - Filtering
    func setFilteredMeteoritesTo(_ filteredMeteorites: [Meteorite]) {
        self.filteredMeteorites = filteredMeteorites
    }
    
    // MARK: - Private
    private func enablePullToResfresh() {
        refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    @objc private func reloadData() {
        meteoriteService.getMeteorites(sinceYear: filterSinceYear) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .failure:
                    self.allMeteorites = []
                case .success(let meteorites):
                    self.allMeteorites = meteorites
                }
                
                self.navigationItem.title = "\(self.allMeteorites.count) Meteorites"
                self.filteredMeteorites = []
                self.refreshControl!.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

