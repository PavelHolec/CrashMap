import UIKit

fileprivate let cardPushedAffineTransform = CGAffineTransform(scaleX: 0.97, y: 0.97).translatedBy(x: 0, y: -5)

class MeteoriteListTableViewCell: UITableViewCell {
    
    private var selectedColor: UIColor?
    
    // MARK: - IBOutlets
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var meteoriteImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var locationUnknownLabel: UILabel!
    @IBOutlet weak var locationUnknownSpacerHeightConstraint: NSLayoutConstraint!
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
            UIView.animate(withDuration: 0.2) {
                self.cardView.transform = cardPushedAffineTransform
                self.shadowView.transform = cardPushedAffineTransform
                self.shadowView.alpha = 0.0
            }
        } else if let selectedColor = selectedColor {
            gradientView.startColor = selectedColor
            UIView.animate(withDuration: 0.2) {
                self.cardView.transform = .identity
                self.shadowView.transform = .identity
                self.shadowView.alpha = 1.0
            }
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
        let imageScale = 0.1 + relativeMass * 0.5
        meteoriteImageView.transform = CGAffineTransform(scaleX: imageScale, y: imageScale)
        massLabelTrailingConstraint.constant = 30 + 40 * relativeMass
    }
    
    private func setBackgroundGradientColors(forRelativeMass relativeMass: CGFloat) {
        let middleLocation = 0.85 - relativeMass * 0.05
        gradientView.middleLocation = middleLocation
        gradientView.endLocation = middleLocation + 0.1
        
        gradientView.startColor = UIColor(named: "TableCellBackground1")!
            .withModified(saturationOffset: relativeMass * 0.02,
                          brightnessOffset: -relativeMass * 0.01)
        
        idLabel.backgroundColor = gradientView.startColor
            .withModified(saturationOffset: -0.2,
                          brightnessOffset: 0.2)
        idLabel.textColor = gradientView.startColor
            .withModified(saturationOffset: -0.1,
                          brightnessOffset: -0.15)
        
        gradientView.middleColor = UIColor(named: "TableCellBackground2")!
            .withModified(saturationOffset: relativeMass * 0.2)
    }
    
    private func setEnabledState(forCoordinates coordinates: Coordinates?) {
        guard let coordinates = coordinates, coordinates.isRangeValid else {
//            nameLabel.alpha = 0.5
//            classLabel.alpha = 0.5
//
//            massLabel.alpha = 0.5
//            shadowView.alpha = 0.0
//            meteoriteImageView.alpha = 0.5
//            locationUnknownSpacerHeightConstraint.constant = 0
//            locationUnknownContentTrailingConstraint.constant = 23
//

            shadowView.alpha = 0.0
            cardView.alpha = 0.6
            cardView.transform = cardPushedAffineTransform
            locationUnknownLabel.alpha = 1.0
            locationUnknownSpacerHeightConstraint.constant = 0
            isUserInteractionEnabled = false
            return
        }
        
//        nameLabel.alpha = 1.0
//        classLabel.alpha = 1.0
//
//        massLabel.alpha = 1.0
//
//        meteoriteImageView.alpha = 1.0

//        locationUnknownContentTrailingConstraint.constant = 20
//
        
        shadowView.alpha = 1.0
        cardView.alpha = 1.0
        cardView.transform = .identity
        locationUnknownLabel.alpha = 0.0
        locationUnknownSpacerHeightConstraint.constant = 18
        isUserInteractionEnabled = true
    }
}
