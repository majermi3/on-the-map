//
//  ViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/15/22.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    var placeholder = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextFIeld.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func handleLogin(success: Bool, error: Error?) {
        if success {
            UdacityClient.loadUser() { success, error in
                self.toggleSpinner(false)
                if success {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    self.showErrorMessage(title: "Login Failed", message: error?.localizedDescription ?? "")
                }
            }
        } else {
            toggleSpinner(false)
            self.showErrorMessage(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func toggleSpinner(_ spin: Bool) {
        if spin {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
        overlayView.isHidden = !spin
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholder = textField.placeholder ?? ""
        textField.placeholder = ""
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "" {
            textField.placeholder = placeholder
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let password = passwordTextFIeld.text
        let email = emailTextField.text
        guard notEmpty(text: password), notEmpty(text: email) else {
            showErrorMessage(title: "Login Failed", message: "Email and password cannot be empty")
            return
        }
        let credentials = UdacityCredentials(username: email!, password: password!)
        
        toggleSpinner(true)
        UdacityClient.createSession(credentials: credentials, completion: handleLogin(success:error:))
    }
}
