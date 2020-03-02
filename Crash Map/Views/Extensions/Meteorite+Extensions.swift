import Foundation
import MapKit

extension Meteorite {
    var mapAnnotation: MKAnnotation? {
        guard let coordinates = coordinates else {
            return nil
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = yearTitle
        annotation.subtitle = fallTitle
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
        return annotation
    }
}
