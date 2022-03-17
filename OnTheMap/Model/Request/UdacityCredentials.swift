//
//  Credentials.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/16/22.
//

import Foundation

struct UdacityCredentials: Codable {
    var udacity: Credentials
    
    init(username: String, password: String) {
        self.udacity = Credentials(username: username, password: password)
    }
}

struct Credentials: Codable {
    var username: String
    var password: String
}
