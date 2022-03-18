//
//  UserResponse.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/18/22.
//

import Foundation

struct UserResponse: Codable {
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
