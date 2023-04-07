//
//  VariousEndpointManager.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

struct MISUPartner: Codable {
    var id: Int
    var title: String
    var text: String
    var link: String
    var logo: String
    var language: String
}

final class VariousEndpointManager {
    
    static let shared: VariousEndpointManager = .init()
    
    func getUserByID(_ id: Int, completion: @escaping (UserModel?) -> ()) {
        let path = "https://misu.pp.ua/api/users/\(id)"
        
        guard let url = URL(string: path) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = KeychainUtility.getCurrentUserToken() {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, _, err in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let decoded = try? JSONDecoder().decode([UserModel].self, from: data) else {
                completion(nil)
                return
            }
            
            completion(decoded.first)
        }
        task.resume()
    }
    
    func fetchMembers(_ completion: @escaping ([MISUPartner]?) -> ()) {
        let path = "https://misu.pp.ua/web/partners"
        
        guard let url = URL(string: path) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("uk", forHTTPHeaderField: "Accept-Language")
        let task = URLSession.shared.dataTask(with: request) { data, _, err in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let decoded = try? JSONDecoder().decode([MISUPartner].self, from: data) else {
                completion(nil)
                return
            }
            completion(decoded)
        }
        task.resume()
    }
}
 
