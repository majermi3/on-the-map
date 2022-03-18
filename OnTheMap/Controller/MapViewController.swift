//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/15/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var addedStudentInformation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let addedStudentInformation = addedStudentInformation {
            StudentData.studentInformation.insert(addedStudentInformation, at: 0)
            addPoint(studentInformation: addedStudentInformation)
            self.addedStudentInformation = nil
        }
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
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func loadData(_ sender: Any?) {
        mapView.removeAnnotations(self.mapView.annotations)
        
        UdacityClient.getStudentLocations(limit: 100) { studentInformation, error in
            if error == nil {
                StudentData.studentInformation = studentInformation
                for info in studentInformation {
                    self.addPoint(studentInformation: info)
                }
            } else {
                self.showErrorMessage(title: "Data cannot be displayed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        super.logout()
    }
}
