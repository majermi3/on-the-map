//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/15/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
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
    
    func addPoint(studentInformation: StudentInformation) {
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(studentInformation.latitude, studentInformation.longitude)

        self.mapView.addAnnotation(annotation)
    }
}
