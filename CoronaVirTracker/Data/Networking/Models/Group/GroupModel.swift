//
//  GroupModel.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 14.12.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation

struct GroupModel {
    let id: Int
    var name: String?
    var admin: UserModel?
    var members: [UserModel] = []
    
//    var isCurrentUserCreator: Bool { admin?.id == RealmUserModel.getCurrent()?.model()?.id }
    var isCurrentUserCreator: Bool { get { return admin?.id == KeyStore.getIntValue(for: .currentUserId) }}
    
    var allMembers: [UserModel] {
        var m = members
        if let a = admin {
            isCurrentUserCreator ? m.append(a) : m.insert(a, at: 0)
        }
        return m
    }
}

extension GroupModel {
    static func deleteUserParams(userId: Int) -> Parameters {
        return [Keys.member.rawValue:[userId]]
    }
}

extension GroupModel: Codable {
    private enum Keys: String, CodingKey {
        case id = "id"
        case name = "name"
        case admin = "creator"
        case members = "members"
        case member = "member"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = container.decode(forKey: .id, defaultValue: -1)
        name = try? container.decode(forKey: .name)
        admin = try? container.decode(forKey: .admin)
        members = container.decode(forKey: .members, defaultValue: [UserModel]())
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(id, forKey: .id)
        try? container.encode(name, forKey: .name)
        try? container.encode(admin, forKey: .admin)
        try? container.encode(members, forKey: .members)
    }
}
