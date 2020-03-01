import Foundation
import UIKit
import MapKit

fileprivate let initialMapZoomDelta = 30.0

class MeteoriteDetailViewController: UIViewController {
    
    let meteorite: Meteorite
    let location: CLLocationCoordinate2D
    
    @IBOutlet weak var mapView: MKMapView!
    
    init?(coder: NSCoder, meteorite: Meteorite) {
        self.meteorite = meteorite
        
        guard let coordinates = meteorite.coordinates, coordinates.isRangeValid else {
            fatalError("Meteorite with no coordinates cannot be selected")
        }
        
        self.location = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = meteorite.name
        mapView.setCenter(location, animated: false)
        addMeteoriteAnnotation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: initialMapZoomDelta, longitudeDelta: initialMapZoomDelta))
        mapView.setRegion(region, animated: true)
    }
    
    func addMeteoriteAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.title = meteorite.yearTitle
        annotation.subtitle = meteorite.fallTitle
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
}
