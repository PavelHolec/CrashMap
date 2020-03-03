import Foundation
import UIKit
import MapKit

extension UIColor {
    public func withModified(hueOffset: CGFloat = 0, saturationOffset: CGFloat = 0, brightnessOffset: CGFloat = 0, alphaOffset: CGFloat = 0) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: (hueOffset + currentHue).clamped,
                           saturation: (saturationOffset + currentSaturation).clamped,
                           brightness: (brightnessOffset + currentBrigthness).clamped,
                           alpha: (alphaOffset + currentAlpha).clamped)
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

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
