import UIKit

class MeteoriteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func configure() {
        nameLabel.text = "x"
        yearLabel.text = "x"
        foundLabel.text = "Found"
        idLabel.text = "1234"
    }
}
