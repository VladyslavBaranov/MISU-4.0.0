//
//  GroupManager+Invite.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 04.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

private struct __GMInvitationModel: Encodable {
    var receiver: String
}

private struct __GMInvitationErrorReponse: Decodable {
    var error: String
    var status: String?
}

struct __GMGetInvitationsModel: Decodable {
    
    struct Entity: Decodable {
        struct Profile: Decodable {
            var id: Int
            var name: String
            var image: String
        }
        var id: Int
        var profile: Profile?
    }
    
    var id: Int
    var sender: Entity
    var recipient: Entity
    var status: String?
    var group: Int
}

extension GroupManager {
    
    func invite(_ phoneNumber: String, completion: @escaping (Int) -> ()) {
        let string = "https://misu.pp.ua/api/request"
        
        guard let url = URL(string: string) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token = KeychainUtility.getCurrentUserToken() {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = try? JSONEncoder().encode(__GMInvitationModel(receiver: phoneNumber))
        
        let task = URLSession.shared.dataTask(with: request) { data, _, err in
            if err != nil {
                completion(1)
                return
            }
            guard let data = data else {
                completion(1)
                return
            }
            
            if let errorResponse = try? JSONDecoder().decode(__GMInvitationErrorReponse.self, from: data) {
                if errorResponse.error == "You cant invite yourself" {
                    completion(2)
                    return
                } else if errorResponse.error == "User is already in a group" {
                    completion(3)
                    return
                }
                if errorResponse.status == nil {
                    completion(4)
                    return
                }
                return
            } else {
                let str = String(data: data, encoding: .utf8) ?? ""
                if str.contains("html") {
                    completion(1)
                    return
                }
                completion(0)
            }
            
        }
        task.resume()
    }
    
    func getInvitations(_ completion: @escaping ([RealmGroupInvitation]) -> ()) {
        let string = "https://misu.pp.ua/api/request"
        
        guard let url = URL(string: string) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = KeychainUtility.getCurrentUserToken() {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(
            with: request
        ) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            guard let invitations = try? JSONDecoder().decode(
                [__GMGetInvitationsModel].self, from: data) else {
                completion([])
                return
            }
            completion(invitations.map { .init($0) })
        }
        task.resume()
    }
    
}
