//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/15/22.
//

import Foundation

struct StudentInformation: Codable {
    var objectId: String
    var uniqueKey: String
    
    var firstName: String
    var lastName: String
    
    var mapString: String
    var mediaURL: String

    var latitude: Double
    var longitude: Double
    
    var createdAt: String
    var updatedAt: String
}
