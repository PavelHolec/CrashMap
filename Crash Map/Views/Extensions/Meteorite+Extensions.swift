import Foundation
import MapKit

extension Meteorite {
    
    class Annotation: MKPointAnnotation {
        let id: String
        
        init(withId id: String) {
            self.id = id
            super.init()
        }
    }
    
    var mapAnnotation: MKAnnotation? {
        guard let coordinates = coordinates else {
            return nil
        }
        
        let annotation = Annotation(withId: id)
        annotation.title = name
        annotation.subtitle = "\(yearTitle), \(fallTitle)"
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.lat,
                                                       longitude: coordinates.lon)
        return annotation
    }
}
