//
//  ViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/15/22.
//

import UIKit

class LoginViewController: BaseViewController {

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
            showErrorMessage(title: "Login Failed", message: "Email and password cannot be empty")
            return
        }
        let credentials = UdacityCredentials(username: email!, password: password!)
        
        UdacityClient.createSession(credentials: credentials, completion: handleLogin(success:error:))
    }
    
    func notEmpty(text: String?) -> Bool {
        return text != nil && text != ""
    }
    
    func handleLogin(success: Bool, error: Error?) {
        if success {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        } else {
            self.showErrorMessage(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
}
