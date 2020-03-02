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

struct Meteorite {
    
    enum Fall: String, Codable {
        case fell = "Fell"
        case found = "Found"
    }

    enum Kind: Int {
        case stony = 1
        case stonyIron = 2
        case iron = 3
    }
    
    let name: String
    let id: String
    let type: String
    let `class`: String
    let kind: Kind
    let massInGrams: Double
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
    var idTitle: String {
        "ID \(id)"
    }
    
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
    
    var massTitle: String {
        guard massInGrams > 0 else {
            return ""
        }
        
        switch massInGrams {
        case ..<1:
            return "\(((massInGrams * 10).rounded()) / 10.0) g"
        case 1000...:
            return "\((massInGrams / 1000).rounded) kg"
        default:
            return "\((massInGrams).rounded) g"
        }
    }
}

extension Meteorite {
    init(fromJson json: Json) {
        name = json.name
        id = json.id
        type = json.nametype
        massInGrams = json.mass == nil ? 0 : Double(json.mass!) ?? 0
        fall = json.fall
        year = Int(String(json.year.prefix(4)))
        
        switch json.recclass {
        case let recclass where recclass.starts(with: "Iron,"):
            kind = .iron
            `class` = json.recclass
        case let recclass where recclass.contains("Pallasite,"):
            kind = .stonyIron
            `class` = json.recclass
        default:
            kind = .stony
            `class` = "Stony, \(json.recclass)"
            break
        }
        
        if let lat = Double(json.reclat), let lon = Double(json.reclong) {
            coordinates = Coordinates(lat: lat, lon: lon)
        } else {
            coordinates = nil
        }
    }
}
