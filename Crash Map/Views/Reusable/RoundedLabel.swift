import Foundation
import UIKit

@IBDesignable class RoundedLabel: UILabel
{
    @IBInspectable var cornerRadius: CGFloat = 3
    @IBInspectable var insets: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    
    override func drawText(in rect: CGRect) {
        let edgeInsets = UIEdgeInsets.init(top: insets, left: insets * 2, bottom: insets, right: insets * 2)
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets * 4,
                      height: size.height)
    }
    
    func sharedInit() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
