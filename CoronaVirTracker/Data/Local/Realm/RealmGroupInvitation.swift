//
//  RealmGroupInvitation.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 06.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import RealmSwift

class RealmGroupInvitation: Object {

    @Persisted var id: Int
    
    @Persisted var senderId: Int
    @Persisted var senderProfileId: Int?
    @Persisted var senderName: String?
    @Persisted var senderImagePath: String?
    
    @Persisted var recipientId: Int
    @Persisted var recipientProfileId: Int?
    @Persisted var recipientName: String?
    @Persisted var recipientImagePath: String?
    
    @Persisted var status: String?
    @Persisted var group: Int
    
}

extension RealmGroupInvitation {
    
    convenience init(_ serverModel: __GMGetInvitationsModel) {
        self.init()
        id = serverModel.id
        
        senderId = serverModel.sender.id
        senderProfileId = serverModel.sender.profile?.id
        senderName = serverModel.sender.profile?.name
        senderImagePath = serverModel.sender.profile?.image
        
        recipientId = serverModel.recipient.id
        recipientProfileId = serverModel.recipient.profile?.id
        recipientName = serverModel.recipient.profile?.name
        recipientImagePath = serverModel.recipient.profile?.image
        
        status = serverModel.status
        group = serverModel.group
    }
    
    static func getAll() -> [RealmGroupInvitation] {
        let realm = try! Realm()
        let objects = realm.objects(RealmGroupInvitation.self)
        return Array(objects)
    }
    
    static func create(_ serverModel: __GMGetInvitationsModel) -> RealmGroupInvitation? {
        let allObjects = getAll()
        if allObjects.contains(where: { $0.id == serverModel.id }) { return nil }
        return RealmGroupInvitation(serverModel)
    }
    
    func save() {
        let realm = try! Realm()
        do {
            try realm.write { [weak self] in
                guard let sSelf = self else { return }
                realm.add(sSelf)
            }
        } catch {}
    }
    
    static func performPreOverwrite() {
        let realm = try! Realm()
        let objects = realm.objects(RealmGroupInvitation.self)
        for object in objects {
            do {
                try realm.write {
                    realm.delete(object)
                }
            } catch {}
        }
    }
}
