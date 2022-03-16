//
//  ViewController.swift
//  OnTheMap
//
//  Created by Gökce Hatipoglu Majernik on 3/15/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: Any) {
        let password = passwordTextFIeld.text
        let email = emailTextField.text
        guard notEmpty(text: password), notEmpty(text: email) else {
            showErrorMessage(message: "Email and password cannot be empty")
            return
        }
    }
    
    func notEmpty(text: String?) -> Bool {
        return text != nil && text != ""
    }
    
    func showErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

