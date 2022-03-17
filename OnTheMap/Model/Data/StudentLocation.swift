//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/17/22.
//

import Foundation
import MapKit

class StudentLocation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(studentInformation: StudentInformation) {
        self.title = studentInformation.fullName()
        self.subtitle = studentInformation.mediaURL
        self.coordinate = CLLocationCoordinate2DMake(studentInformation.latitude, studentInformation.longitude)
    }
}
