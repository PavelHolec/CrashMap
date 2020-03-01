import Foundation
import UIKit

extension UIColor {
    public func withModified(hueOffset: CGFloat = 0, saturationOffset: CGFloat = 0, brightnessOffset: CGFloat = 0) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: (hueOffset + currentHue).clamped,
                           saturation: (saturationOffset + currentSaturation).clamped,
                           brightness: (brightnessOffset + currentBrigthness).clamped,
                       alpha: currentAlpha)
        } else {
            return self
        }
    }
}

extension CGFloat {
    var clamped: CGFloat {
        Swift.min(Swift.max(self, 0.0), 1.0)
    }
}
