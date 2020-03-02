import Foundation
import UIKit

extension Double {
    var rounded: Int {
        Int(ceil(self))
    }
    
    /// Remaps an input numeric range to 0..1
    func remap(from: Double, to: Double, curve: UIView.AnimationCurve = .easeOut) -> Double {
        let linearMap = Swift.min((Swift.max(self - from, 0.0) / (to - from)), 1.0)
        
        switch curve {
        case .linear:
            return linearMap
        case .easeOut:
            return -linearMap * (linearMap - 2.0)
        case .easeIn:
            return linearMap * linearMap
        case .easeInOut:
            if linearMap < 0.5 {
                return 2.0 * linearMap * linearMap
            } else {
                return (-2.0 * linearMap * linearMap) + (4.0 * linearMap) - 1.0
            }
        @unknown default:
            return linearMap
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
//
//extension Array where Element: Hashable {
//    /// Returns di
//    func difference(from other: [Element]) -> (inserted: [Element], removed: [Element]) {
//        return self.difference(from: other)
//
//
//        if self.count == 0 {
//            return (inserted: [], removed: other)
//        }
//
//        if other.count == 0 {
//            return (inserted: self, removed: [])
//        }
//
//        let thisSet = Set(self)
//        let otherSet = Set(other)
//        return (added: Array(thisSet.dif),
//                removed: Array(thisSet.symmetricDifference(otherSet)))
//    }
//}
