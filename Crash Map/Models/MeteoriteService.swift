import Foundation

struct MeteoriteService {
    
    var meteorites: [Meteorite] {
        [Meteorite(id: "1", name: "Meteorite", year: "1999", type: "x", fall: "Fall", mass: 3.34, location: (50.2, 49.1)),
         Meteorite(id: "2", name: "Meteorite 2", year: "1999", type: "x", fall: "Fall", mass: 0.24, location: (40.2, 51.1)),
         Meteorite(id: "3", name: "Meteorite 3", year: "1989", type: "x", fall: "Fall", mass: 100.34, location: (51.2, 49.1))]
    }
    
    func getMeteorite(index: Int) -> Meteorite {
        meteorites[index]
    }
}
