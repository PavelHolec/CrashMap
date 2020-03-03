import UIKit

fileprivate let cardPushedAffineTransform = CGAffineTransform(scaleX: 0.97, y: 0.97).translatedBy(x: 0, y: -5)

class MeteoriteListTableViewCell: UITableViewCell {
    
    private var selectedColor: UIColor?
    private var relativeMass: CGFloat!
    private(set) var meteorite: Meteorite!
    
    // MARK: - IBOutlets
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var dotWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var meteoriteImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var locationUnknownSpacerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var massLabelTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - View
    override func awakeFromNib() {
        super.awakeFromNib()
        yearLabel.font = UIFont.systemFont(ofSize: yearLabel.font.pointSize, weight: .bold)
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize, weight: .bold)
        massLabel.font = UIFont.systemFont(ofSize: massLabel.font.pointSize, weight: .medium)
    }
    
    // MARK: - Configuration
    func setCustomHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            if animated {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3,
                               initialSpringVelocity: 5, options: .curveEaseOut,
                               animations: setHighlightedStyle, completion: nil)
            } else {
                self.setHighlightedStyle()
            }
        } else {
            if animated {
                UIView.animate(withDuration: 0.3, animations: setNormalStyle)
            } else {
                self.setNormalStyle()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            if animated {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3,
                               initialSpringVelocity: 5, options: .curveEaseOut,
                               animations: setSelectedStyle, completion: nil)
            } else {
                self.setSelectedStyle()
            }
        } else {
            if animated {
                UIView.animate(withDuration: 0.3, animations: setNormalStyle)
            } else {
                self.setNormalStyle()
            }
        }
        
        setIdColors()
    }
    
    func setHighlightedStyle() {
        cardView.transform = cardPushedAffineTransform
        shadowView.transform = cardPushedAffineTransform
        shadowView.alpha = 0.0
        setIdColors()
    }
    
    func setSelectedStyle() {
        setHighlightedStyle()
        gradientView.startColor = UIColor(named: "TableCellSelected")!
        gradientView.middleColor = UIColor(named: "TableCellBackground2")!
        yearLabel.textColor = .label
        foundLabel.textColor = .secondaryLabel
        
        dotWidthConstraint.constant = 8
        dotView.backgroundColor = UIColor(named: "Color1")
        dotView.layer.cornerRadius = 4
    }
    
    func setNormalStyle() {
        setBackgroundGradientColors()
        yearLabel.textColor = .secondaryLabel
        foundLabel.textColor = .tertiaryLabel
        
        cardView.transform = .identity
        shadowView.transform = .identity
        shadowView.alpha = 1.0
        dotWidthConstraint.constant = 5
        
        dotView.backgroundColor = .quaternaryLabel
        dotView.layer.cornerRadius = 4
        setIdColors()
        
        setEnabledOrDisabledState()
    }
    
    func configure(meteorite: Meteorite) {
        self.meteorite = meteorite
        
        nameLabel.text = meteorite.name
        accessibilityLabel = meteorite.name
        yearLabel.text = meteorite.yearTitle
        foundLabel.text = meteorite.fallTitle
        idLabel.text = meteorite.idTitle
        accessibilityIdentifier = meteorite.idTitle
        
        massLabel.text = meteorite.massTitle
        classLabel.text = meteorite.class
        
        classLabel.backgroundColor = UIColor(named: "Color\(meteorite.kind.rawValue)")
        
        meteoriteImageView.isHidden = meteorite.massInGrams > 0 ? false : true
        
        relativeMass = CGFloat(meteorite.massInGrams.remap(from: 0, to: 10_000, curve: .easeIn))
        
        scaleMeteoriteImage()
        setEnabledOrDisabledState()
    }
    
    // MARK: - Privates
    private func scaleMeteoriteImage() {
        let imageScale = 0.1 + relativeMass * 0.5
        meteoriteImageView.transform = CGAffineTransform(scaleX: imageScale, y: imageScale)
        massLabelTrailingConstraint.constant = 40 + 55 * relativeMass
    }
    
    private func setBackgroundGradientColors() {
        let middleLocation = 0.85 - relativeMass * 0.05
        gradientView.startColor = UIColor(named: "TableCellBackground1")!
        gradientView.middleLocation = middleLocation
        gradientView.endLocation = middleLocation + 0.1
        gradientView.middleColor = UIColor(named: "TableCellBackground2")!
            .withModified(saturationOffset: relativeMass * 0.2)
    }
    
    private func setIdColors() {
//        idLabel.textColor = gradientView.startColor
//            .withModified(saturationOffset: -0.1,
//                          brightnessOffset: 0.15)
    }
    
    private func setEnabledOrDisabledState() {
        guard let coordinates = meteorite.coordinates, coordinates.isRangeValid else {
            shadowView.alpha = 0.0
            cardView.alpha = 0.6
            cardView.transform = cardPushedAffineTransform
            locationUnknownSpacerHeightConstraint.constant = 0
            isUserInteractionEnabled = false
            return
        }

        shadowView.alpha = 1.0
        cardView.alpha = 1.0
        cardView.transform = .identity
        locationUnknownSpacerHeightConstraint.constant = 18
        isUserInteractionEnabled = true
    }
}
