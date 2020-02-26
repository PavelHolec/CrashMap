import UIKit

class MeteoriteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func configure(meteorite: Meteorite) {
        nameLabel.text = meteorite.name
        yearLabel.text = meteorite.year
        foundLabel.text = meteorite.fall
        idLabel.text = meteorite.id
    }
}
