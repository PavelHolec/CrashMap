import Foundation
import UIKit
import MapKit

fileprivate let reusableAnnotationIdentifier = "meteoriteAnnotation"

extension MeteoriteListTableViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Meteorite.Annotation else {
            assertionFailure("Not a Meteorite.Annotation")
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reusableAnnotationIdentifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reusableAnnotationIdentifier)
    
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "meteorite-stone")
        annotationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        guard let annotation = view.annotation as? Meteorite.Annotation else {
            assertionFailure("Not a Meteorite.Annotation ")
            return
        }

        guard let selectedIndex = meteorites.firstIndex(where: { $0.id == annotation.id }) else {
            assertionFailure("No matching MeteoriteAnnotationView id in a list")
            return
        }
        
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            mapView.setCenter(annotation.coordinate, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
}
