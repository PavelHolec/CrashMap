import Foundation

struct Coordinates {
    let lat: Double
    let lon: Double
    
    var isRangeValid: Bool {
        -90...90 ~= lat &&
        -180...180 ~= lon &&
        (lat != 0 && lon != 0)
    }
}
