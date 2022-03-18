//
//  CreateStudentInformationStep2ViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/17/22.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

class CreateStudentInformationStep2ViewController: BaseViewController {
    
    let placeholder = "Enter a Link to Share Here"
    var coordinates: CLLocationCoordinate2D!
    var mapString: String!
    var studentInformation: StudentInformation!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let date = getFormattedDate()
        studentInformation = StudentInformation(
            objectId: "",
            uniqueKey: UdacityClient.User.id,
            firstName: UdacityClient.User.firstName,
            lastName: UdacityClient.User.lastName,
            mapString: mapString,
            mediaURL: "",
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            createdAt: date,
            updatedAt: date
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let annotation = StudentLocation(studentInformation: studentInformation)
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: CLLocationDistance(exactly: 5000)!,
            longitudinalMeters: CLLocationDistance(exactly: 5000)!
        )
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        guard notEmpty(text: linkTextField.text) else {
            showErrorMessage(title: "Submit Failed", message: "Please add a Link to Share")
            return
        }
        let link = setMissingScheme(urlString: linkTextField.text!)
        guard isURLValid(urlString: link) else {
            showErrorMessage(title: "Submit Failed", message: "Shared Link is invalid")
            return
        }
        
        studentInformation.mediaURL = link
        
        UdacityClient.createStudenInformation(studentInformation: studentInformation) { studentInformationResponse, error in
            if let error = error {
                self.showErrorMessage(title: "Submit Failed", message: error.localizedDescription)
                return
            }
            if let studentInformationResponse = studentInformationResponse {
                // TODO
                self.goToListView()
            } else {
                self.showErrorMessage(title: "Submit Failed", message: "Please try again later")
            }
        }
    }

    func goToListView() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getFormattedDate() -> String {
        let now = Date.now
        return now.formatted(date: .abbreviated, time: .omitted)
    }
    
    func setMissingScheme(urlString: String) -> String {
        if !urlString.hasPrefix("http") {
            return "https://\(urlString)"
        }
        return urlString
    }
    
    func isURLValid(urlString: String) -> Bool {
        let url = URL(string: urlString)
        return url?.host != nil && url?.scheme != nil
    }
}
