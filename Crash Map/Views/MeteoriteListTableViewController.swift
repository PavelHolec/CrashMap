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
    @IBOutlet private var mapView: MKMapView!
    
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
        
        mapView.setRegion(MKCoordinateRegion(MKMapRect.world), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    func refresh() {
        reloadAnnotations()
        tableView.reloadData()
    }
    
    private func reloadAnnotations() {
        let previousAnnotations = mapView.annotations.map { $0 }
        let currentAnnotations = meteorites.compactMap { $0.mapAnnotation }
        
        let annotationsDiffs = currentAnnotations.difference(from: previousAnnotations) { $0.coordinate == $1.coordinate }
        
        for annotationDiff in annotationsDiffs {
            switch annotationDiff {
            case let .remove(_, annotation, _):
                self.mapView.removeAnnotation(annotation)
            case let .insert(_, annotation, _):
                self.mapView.addAnnotation(annotation)
            }
        }
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
        cell.set(isSelected: true)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MeteoriteListTableViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.set(isSelected: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MeteoriteListTableViewCell
        
        DispatchQueue.main.async { [weak self] in
            guard let annotationToSelect = self?.mapView.annotations[safe: indexPath.row] else {
                return
            }
            self?.mapView.selectAnnotation(annotationToSelect, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.set(isSelected: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let gradientViewTop = tableHeaderView.subviews[1] as! GradientView
        gradientViewTop.endColor = UIColor.systemBackground.withModified(alphaOffset: -1.0)
        let gradientViewMiddle = tableHeaderView.subviews[2] as! GradientView
        gradientViewMiddle.startColor = UIColor.systemBackground.withModified(alphaOffset: -1.0)
        let gradientViewBottom = tableHeaderView.subviews[4] as! GradientView
        gradientViewBottom.endColor = UIColor.systemBackground.withModified(alphaOffset: -1.0)
        return meteorites.count > 0 ? tableHeaderView : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return meteorites.count > 0 ? tableView.bounds.height * 0.55 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return meteorites.count > 0 ? nil : emptyTableView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return meteorites.count > 0 ? 0 : tableView.bounds.height * 0.6
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationItem.searchController?.searchBar.alpha = min(scrollView.contentOffset.y, 50) / 50
    }
    
    // MARK: - Segues
    @IBSegueAction
    func makeMeteoriteDetailViewController(coder: NSCoder) -> UIViewController? {
        let selectedMeteorite = meteorites[tableView.indexPathForSelectedRow!.row]
        return MeteoriteDetailViewController(coder: coder, meteorite: selectedMeteorite)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
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
                
                self.refresh()
            }
        }
    }
}
