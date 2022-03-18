//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/15/22.
//

import Foundation
import UIKit

class ListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentData.studentInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInformationCell")!
        
        let studentInformation = StudentData.studentInformation[indexPath.row]
        
        cell.textLabel?.text = studentInformation.fullName()
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInformation = StudentData.studentInformation[indexPath.row]
        
        if let url = URL(string: studentInformation.mediaURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showErrorMessage(title: "Invalid URL", message: "The URL of this student is missing or is invalid.")
        }
    }
    
    @IBAction func loadData(_ sender: Any?) {
        UdacityClient.getStudentLocations(limit: 100) { studentInformation, error in
            if error == nil {
                StudentData.studentInformation = studentInformation
                self.tableView.reloadData()
            } else {
                self.showErrorMessage(title: "Data cannot be displayed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        super.logout()
    }
}
