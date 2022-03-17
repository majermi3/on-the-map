//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/16/22.
//

import Foundation

struct LoginResponse: Codable {
    var account: Account
    var session: Session
}

struct Account: Codable {
    var registered: Bool
    var key: String
}

struct Session: Codable {
    var id: String
    var expiration: String
}
