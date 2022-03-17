//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/15/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UdacityClient.getStudentLocations(limit: 100) { studentInformation, error in
            // TODO Handle error
            DispatchQueue.main.async {
                StudentData.studentInformation = studentInformation
                for info in studentInformation {
                    self.addPoint(studentInformation: info)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StudentLocation else {
            return nil
        }
        let identifier = "studentLocation"
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            return dequeuedView
        }
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func addPoint(studentInformation: StudentInformation) {
        let annotation = StudentLocation(studentInformation: studentInformation)
        self.mapView.addAnnotation(annotation)
    }
}
