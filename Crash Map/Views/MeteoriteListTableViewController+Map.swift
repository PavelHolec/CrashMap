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
        
        var annotationView: MKAnnotationView!
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: reusableAnnotationIdentifier) {
            annotationView = dequeuedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: reusableAnnotationIdentifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.image = UIImage(named: "meteorite-stone")
        }

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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let region = MKCoordinateRegion(center: view.annotation!.coordinate, span: mapView.region.span)
            mapView.setRegion(region, animated: true)
        }
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            
//            if let cell = self.tableView.cellForRow(at: indexPath) as? MeteoriteListTableViewCell {
//                cell.setSelected(true, animated: true)
//            }
            
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.scrollRowToVisible(at: indexPath)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "meteoriteDetail", sender: self)
    }
}
