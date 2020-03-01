import UIKit

class MeteoriteListTableViewCell: UITableViewCell {
    
    private var selectedColor: UIColor?
    
    // MARK: - IBOutlets
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var meteoriteImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var massLabelTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - View
    override func awakeFromNib() {
        super.awakeFromNib()
        yearLabel.font = UIFont.systemFont(ofSize: yearLabel.font.pointSize, weight: .bold)
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize, weight: .bold)
        idLabel.font = UIFont.systemFont(ofSize: idLabel.font.pointSize * 0.7)
    }
    
    // MARK: - Configuration
    func set(selected: Bool) {
        if selected {
            selectedColor = gradientView.startColor
            gradientView.startColor = UIColor(named: "TableCellSelected")!
        } else if let selectedColor = selectedColor {
            gradientView.startColor = selectedColor
        }
    }
    
    func configure(meteorite: Meteorite) {
        nameLabel.text = meteorite.name
        yearLabel.text = meteorite.yearTitle
        foundLabel.text = meteorite.fallTitle
        idLabel.text = meteorite.idTitle
        
        massLabel.text = meteorite.massTitle
        classLabel.text = meteorite.class
        
        let relativeMass = CGFloat(meteorite.massInGrams.remap(from: 0, to: 10_000, curve: .easeIn))
        
        scaleMeteoriteImage(toRelativeMass: relativeMass)
        setBackgroundGradientColors(forRelativeMass: relativeMass)
        setEnabledState(forCoordinates: meteorite.coordinates)
        
        meteoriteImageView.isHidden = meteorite.massInGrams > 0 ? false : true
    }
    
    // MARK: - Privates
    private func scaleMeteoriteImage(toRelativeMass relativeMass: CGFloat) {
        let imageScale = 0.1 + relativeMass
        meteoriteImageView.transform = CGAffineTransform(scaleX: imageScale, y: imageScale)
        massLabelTrailingConstraint.constant = 30 + 80 * relativeMass
    }
    
    private func setBackgroundGradientColors(forRelativeMass relativeMass: CGFloat) {
        let middleLocation = 0.85 - relativeMass * 0.05
        gradientView.middleLocation = middleLocation
        gradientView.endLocation = middleLocation + 0.1
        
        gradientView.startColor = UIColor(named: "TableCellBackground1")!
            .withModified(saturationOffset: relativeMass * 0.2,
                          brightnessOffset: -relativeMass * 0.03)
        
        gradientView.middleColor = UIColor(named: "TableCellBackground2")!
            .withModified(saturationOffset: relativeMass * 0.2)
    }
    
    private func setEnabledState(forCoordinates coordinates: Coordinates?) {
        if coordinates == nil {
            gradientView.alpha = 0.3
            nameLabel.alpha = 0.6
            classLabel.alpha = 0.6
            massLabel.alpha = 0.6
            shadowView.alpha = 0.0
        } else {
            gradientView.alpha = 1.0
            nameLabel.alpha = 1.0
            classLabel.alpha = 1.0
            massLabel.alpha = 1.0
            shadowView.alpha = 1.0
        }
    }
}
