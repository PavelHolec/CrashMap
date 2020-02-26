import Foundation
import UIKit
import MapKit

class MeteoriteDetailViewController: UIViewController {
    
    let meteorite: Meteorite
    
    @IBOutlet weak var mapView: MKMapView!
    
    init?(coder: NSCoder, meteorite: Meteorite) {
        self.meteorite = meteorite
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = meteorite.name
        
        let location = CLLocationCoordinate2D(latitude: meteorite.location.lat, longitude: meteorite.location.lon)
        mapView.setCenter(location, animated: false)
    }
}
