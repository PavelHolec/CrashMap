import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    @IBInspectable var startLocation: CGFloat = 0.0
    
    @IBInspectable var middleColor: UIColor = UIColor.clear
    @IBInspectable var middleLocation: CGFloat = 0.5
    
    @IBInspectable var endColor: UIColor = UIColor.clear
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 0)
    @IBInspectable var endLocation: CGFloat = 1.0

    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
        gradient.locations = [startLocation, middleLocation, endLocation].map { $0 as NSNumber }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.zPosition = -1
        layer.addSublayer(gradient)
    }
}
