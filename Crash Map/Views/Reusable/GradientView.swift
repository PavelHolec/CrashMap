import UIKit

/// View with a 3 color linear gradient
@IBDesignable class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet {
            setGradient()
        }
    }
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            setGradient()
        }
    }
    @IBInspectable var startLocation: CGFloat = 0.0 {
        didSet {
            setGradient()
        }
    }
    
    @IBInspectable var middleColor: UIColor = UIColor.clear {
        didSet {
            setGradient()
        }
    }
    @IBInspectable var middleLocation: CGFloat = 0.5 {
        didSet {
            setGradient()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.clear {
        didSet {
            setGradient()
        }
    }
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 0) {
        didSet {
            setGradient()
        }
    }
    @IBInspectable var endLocation: CGFloat = 1.0 {
        didSet {
            setGradient()
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradient()
    }
    
    private func setGradient() {
        (layer as! CAGradientLayer).colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
        (layer as! CAGradientLayer).locations = [startLocation, middleLocation, endLocation].map { $0 as NSNumber }
        (layer as! CAGradientLayer).startPoint = startPoint
        (layer as! CAGradientLayer).endPoint = endPoint
    }
}
