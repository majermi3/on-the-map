//
//  CreateStudentInformationViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/17/22.
//

import Foundation
import UIKit
import CoreLocation

class CreateStudentInformationViewController: BaseViewController, UITextFieldDelegate {
    
    let placeholder = "Enter Your Location Here"
    var coordinates: CLLocationCoordinate2D?
    
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        locationTextField.placeholder = ""
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if locationTextField.placeholder == "" {
            locationTextField.placeholder = placeholder
        }
    }
    
    @IBAction func findOnMap(_ sender: Any) {
        let locationText = locationTextField.text
        guard notEmpty(text: locationText) else {
            showErrorMessage(title: "Localization Failed", message: "Location cannot be empty")
            return
        }
        
        CLGeocoder().geocodeAddressString(locationText!) { placemarks, error in
            if error != nil {
                self.showErrorMessage(title: "Localization Failed", message: "Location not found")
                return
            }
            
            if let placemark = placemarks?.first?.location?.coordinate {
                self.coordinates = CLLocationCoordinate2DMake(placemark.latitude, placemark.longitude)
                self.performSegue(withIdentifier: "step2", sender: nil)
            } else {
                self.showErrorMessage(title: "Localization Failed", message: "Location not found")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "step2" {
            let step2VC = segue.destination as! CreateStudentInformationStep2ViewController
            step2VC.coordinates = coordinates
            step2VC.mapString = locationTextField.text!
        }
    }
}
