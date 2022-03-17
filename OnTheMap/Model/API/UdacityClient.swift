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
        case studenLocation(limit: Int)
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "/session"
            case .studenLocation(let limit): return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=\(limit)"
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
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let newData = removeFirst5Characters(data: data!)
            let decoder = JSONDecoder()
            do {
                let loginResponse = try decoder.decode(LoginResponse.self, from: newData)
                Auth.sessionId = loginResponse.session.id
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(limit: Int = 100, completion: @escaping ([StudentInformation], Error?) -> Void) {
        let request = URLRequest(url: Endpoints.studenLocation(limit: limit).url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let studentInformationResponse = try decoder.decode(StudentInformationResponse.self, from: data!)
                DispatchQueue.main.async {
                    completion(studentInformationResponse.results, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data!) as Error
                    DispatchQueue.main.async {
                        completion([], errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion([], error)
                    }
                }
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
