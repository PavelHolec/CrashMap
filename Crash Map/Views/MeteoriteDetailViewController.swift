import Foundation
import UIKit
import MapKit

class MeteoriteDetailViewController: UIViewController {
    
    let meteorite: Meteorite
    let location: CLLocationCoordinate2D
    
    @IBOutlet weak var mapView: MKMapView!
    
    init?(coder: NSCoder, meteorite: Meteorite) {
        self.meteorite = meteorite
        
        guard let coordinates = meteorite.coordinates else {
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
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        mapView.setRegion(region, animated: true)
    }
    
    func addMeteoriteAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.title = meteorite.name
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
}
