//
//  AuthManagerV2.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 22.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

fileprivate struct AuthModelLogin: Codable {
    var mobile: String
    var token: String
}

fileprivate struct AuthModelLoginResponse: Decodable {
    var token: String
}

fileprivate struct AuthModelCheck: Codable {
    var username: String
}

struct AuthModelCheckResponse: Decodable {
    var detail: Bool
    var doctor: Bool
    var profile: Bool
}

final class AuthManagerV2 {
    
    static let shared = AuthManagerV2()
    
    func signIn(_ number: String, token: String, completion: @escaping (String?) -> ()) {
        
        let model = AuthModelLogin(mobile: number, token: token)
        
        var request = URLRequest(url: URL(string: "https://misu.pp.ua/api/login")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(model)
        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            if let _ = err {
                completion(nil)
            }
            if let data = data {
                if let object = try? JSONDecoder().decode(AuthModelLoginResponse.self, from: data) {
                    completion(object.token)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func checkUser(_ number: String, completion: @escaping (AuthModelCheckResponse?) -> ()) {
        let model = AuthModelCheck(username: number)
        
        var request = URLRequest(url: URL(string: "https://misu.pp.ua/auth/check")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(model)
        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            if let _ = err {
                completion(nil)
            }
            if let data = data {
                if let object = try? JSONDecoder().decode(AuthModelCheckResponse.self, from: data) {
                    completion(object)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
