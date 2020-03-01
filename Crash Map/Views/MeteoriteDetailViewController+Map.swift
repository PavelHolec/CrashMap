import Foundation
import UIKit
import MapKit

fileprivate let reusableAnnotationIdentifier = "meteoriteAnnotation"

extension MeteoriteDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reusableAnnotationIdentifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reusableAnnotationIdentifier)
    
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "meteorite-stone")
        //annotationView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        return annotationView
    }
}
