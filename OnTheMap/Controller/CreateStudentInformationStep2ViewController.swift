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

class CreateStudentInformationStep2ViewController: BaseViewController, UITextFieldDelegate {
    
    let placeholder = "Enter a Link to Share Here"
    var coordinates: CLLocationCoordinate2D!
    var mapString: String!
    var studentInformation: StudentInformation!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        linkTextField.placeholder = ""
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if linkTextField.placeholder == "" {
            linkTextField.placeholder = placeholder
        }
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
        toggleSpinner(true)
        UdacityClient.createStudenInformation(studentInformation: studentInformation) { studentInformationResponse, error in
            self.toggleSpinner(false)
            if let error = error {
                self.showErrorMessage(title: "Submit Failed", message: error.localizedDescription)
                return
            }
            if let studentInformationResponse = studentInformationResponse {
                self.studentInformation.objectId = studentInformationResponse.objectId
                self.goToListView()
            } else {
                self.showErrorMessage(title: "Submit Failed", message: "Please try again later")
            }
        }
    }

    func goToListView() {
        if let mapVC  = self.navigationController?.viewControllers[0] as? MapViewController {
            mapVC.addedStudentInformation = studentInformation
            navigationController?.popToViewController(mapVC, animated: true)
        } else if let listVC = self.navigationController?.viewControllers[0] as? ListViewController {
            listVC.addedStudentInformation = studentInformation
            navigationController?.popToViewController(listVC, animated: true)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    func toggleSpinner(_ spin: Bool) {
        if spin {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
        overlayView.isHidden = !spin
    }
}
