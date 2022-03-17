//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/15/22.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UdacityClient.getStudentLocations(limit: 100) { studentInformation, error in
            DispatchQueue.main.async {
                StudentData.studentInformation = studentInformation
                self.tableView.reloadData()
            }
        }
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
    
}
