import Foundation
import UIKit

@IBDesignable class RoundedLabel: UILabel
{
    @IBInspectable var cornerRadius: CGFloat = 1 {
        didSet {
            sharedInit()
        }
    }
    @IBInspectable var insets: CGFloat = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    
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
        let edgeInsets = UIEdgeInsets.init(top: insets,
                                           left: floor(insets * 1.5),
                                           bottom: insets,
                                           right: floor(insets * 1.5))
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: ceil(size.width + insets * 3),
                      height: ceil(size.height))
    }
    
    func sharedInit() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
