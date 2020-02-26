import Foundation
import UIKit

class MeteoriteListTableViewController: UITableViewController {
    
    let meteoriteService = MeteoriteService()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meteoriteService.meteorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meteoriteCell = tableView.dequeueReusableCell(withIdentifier: "Meteorite Cell") as! MeteoriteListTableViewCell
        meteoriteCell.configure(meteorite: meteoriteService.meteorites[indexPath.row])
        return meteoriteCell
    }
    
    @IBSegueAction
    func makeMeteoriteDetailViewController(coder: NSCoder) -> UIViewController? {
        let selectedMeteorite = meteoriteService.getMeteorite(index: tableView!.indexPathForSelectedRow!.row)
        return MeteoriteDetailViewController(coder: coder, meteorite: selectedMeteorite)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
