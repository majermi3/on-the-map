//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/17/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func showErrorMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func logout() {
        UdacityClient.logoutUser() { success, error in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showErrorMessage(title: "Logout Failed", message: error?.localizedDescription ?? "")
            }
        }
    }
}
