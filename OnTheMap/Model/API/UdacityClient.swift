//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Michal Majernik on 3/16/22.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func createSession(credentials: UdacityCredentials, completion: @escaping (Bool, Error?) -> Void) {
        var request = getRequestWithHeaders(url: Endpoints.session.url)
        request.httpBody = try! JSONEncoder().encode(credentials)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
                return
            }
            let newData = removeFirst5Characters(data: data!)
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: newData)
                Auth.sessionId = loginResponse.session.id
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    private class func getRequestWithHeaders(url: URL, method: String = "POST") -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private class func removeFirst5Characters(data: Data) -> Data {
        let range = 5..<data.count
        return data.subdata(in: range)
    }
}
