//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Gökce Hatipoglu Majernik on 3/17/22.
//

import Foundation

struct ErrorResponse: LocalizedError, Codable {
    var status: Int
    var error: String
    
    var errorDescription: String? {
        return error
    }
}
