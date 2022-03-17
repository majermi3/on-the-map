//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Gökce Hatipoglu Majernik on 3/17/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func showErrorMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
