import UIKit

class MeteoriteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var meteoriteImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellSelectedColor(UIColor(named: "TableCellSelected")!)
        
//        meteoriteImageView.frame = CGRect(x: bounds.maxX - 100, y: bounds.maxY - 85, width: 80, height: 80)
//        meteoriteImageView.layer.anchorPoint = CGPoint(x: 0.84, y: 0.63)
        meteoriteImageView.transform = .identity
    }
    
    var color: UIColor? {
        get {
            return shadowView.backgroundColor
        }
        set {
            shadowView.backgroundColor = newValue
        }
    }
    
    func configure(meteorite: Meteorite) {
        nameLabel.text = meteorite.name
        yearLabel.text = meteorite.yearTitle
        foundLabel.text = meteorite.fallTitle
        idLabel.text = meteorite.idTitle
        
        massLabel.text = meteorite.massTitle
        classLabel.text = meteorite.class
        
        if meteorite.massInGrams > 0 {
            let scale = 0.25 + CGFloat(20 * meteorite.massInGrams / 1_000_000)
            meteoriteImageView.transform = CGAffineTransform(scaleX: scale, y: scale).rotated(by: -0.2)
            meteoriteImageView.isHidden = false
            //gradientView.middleLocation = CGFloat(0.75 - meteorite.massInGrams / 1_0_000.0)
        } else {
            meteoriteImageView.isHidden = true
        }
        
        if meteorite.coordinates == nil {
            selectionStyle = .none
        }
    }
}
