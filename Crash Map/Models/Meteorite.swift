import Foundation

enum Fall: String, Codable {
    case fell = "Fell"
    case found = "Found"
}

typealias Coordinates = (lat: Double, lon: Double)

struct Meteorite {
    
    let name: String
    let id: String
    let type: String
    let `class`: String
    let massInGrams: Int?
    let fall: Fall
    let year: Int?
    let coordinates: Coordinates?
    
    struct Json: Decodable {
        let name: String
        let id: String
        let nametype: String
        let recclass: String
        let mass: String?
        let fall: Fall
        let year: String
        let reclat: String
        let reclong: String
    }
    
    // MARK: VM
    var yearTitle: String {
        year == nil ? "" : String(year!)
    }
    
    var fallTitle: String {
        switch fall {
        case .fell:
            return "Fell"
        case .found:
            return "Found"
        }
    }
}

extension Meteorite {
    init(fromJson json: Json) {
        name = json.name
        id = json.id
        type = json.nametype
        `class` = json.recclass
        massInGrams = json.mass == nil ? nil : Int(json.mass!)
        fall = json.fall
        year = Int(String(json.year.prefix(4)))
        
        if let lat = Double(json.reclat), let lon = Double(json.reclong) {
            coordinates = Coordinates(lat: lat, lon: lon)
        } else {
            coordinates = nil
        }
    }
}
