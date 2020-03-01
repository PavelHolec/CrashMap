import Foundation
import UIKit

extension UIColor {

    public func withModified(hueOffset: CGFloat = 0, saturationOffset: CGFloat = 0, brightnessOffset: CGFloat = 0) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: hueOffset + currentHue,
                       saturation: saturationOffset + currentSaturation,
                       brightness: brightnessOffset + currentBrigthness,
                       alpha: currentAlpha)
        } else {
            return self
        }
    }
}
