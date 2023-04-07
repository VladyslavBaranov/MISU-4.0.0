//
//  RealmChat.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 24.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import RealmSwift

class RealmMessage: Object {
    
    @Persisted var chatId: Int
    @Persisted var senderId: Int
    
    @Persisted var string: String
    @Persisted var date: Date
    
    @Persisted var wasSeen: Bool
    @Persisted var isSync: Bool
    
    static func createFrom(_ model: MessageModel, in chat: ChatV2) -> RealmMessage {
        let msg = RealmMessage()
        msg.chatId = chat.id
        msg.senderId = model.sender ?? 0
        msg.string = model.text ?? ""
        msg.date = model.dateTimeString?.toDate() ?? Date()
        msg.wasSeen = false
        msg.isSync = true
        return msg
    }
    
    func setIsSync() {
        let realm = try! Realm()
        do {
            try realm.write { [weak self] in
                self?.isSync = true
            }
        } catch {}
    }
}

extension RealmMessage {
    
    static func delete(_ message: RealmMessage) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(message)
            }
        } catch {}
    }
    
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL d HH:mm"
        return formatter.string(from: date)
    }
    
    static func clear() {
        let realm = try! Realm()
        let messages = realm.objects(RealmMessage.self)
        realm.writeAsync {
            for message in messages {
                realm.delete(message)
            }
        }
    }
    
    static func save(_ msg: RealmMessage) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(msg)
            }
        } catch {}
    }
    
    static func getMessages(for chat: ChatV2) -> [RealmMessage] {
        let realm = try! Realm()
        let objects = realm.objects(RealmMessage.self)
            .where { $0.chatId == chat.id }
        return Array(objects)
    }
    
    static func getUnreadMessagesCount(for chat: ChatV2) -> Int {
        let realm = try! Realm()
        let objects = realm.objects(RealmMessage.self)
            .filter { $0.chatId == chat.id && !$0.wasSeen }
        return objects.count
    }
    
    static func getUnreadMessagesCount() -> Int {
        let realm = try! Realm()
        let objects = realm.objects(RealmMessage.self)
            .filter { !$0.wasSeen }
        return objects.count
    }
    
    static func saveChat(from messages: [MessageModel], chat: ChatV2) {
        let rlm = try! Realm()
        let allForChat = getMessages(for: chat)
        let dates = allForChat.map { $0.date }
        for model in messages {
            let date = model.dateTimeString?.toDate() ?? Date()
            if !dates.contains(date) {
                let msg = RealmMessage.createFrom(model, in: chat)
                do {
                    try rlm.write {
                        rlm.add(msg)
                    }
                } catch {}
            }
        }
    }
    
    static func setAllWasSeen(in chat: ChatV2) {
        let rlm = try! Realm()
        let messages = rlm.objects(RealmMessage.self).filter { $0.chatId == chat.id }
        for message in messages.filter({ !$0.wasSeen }) {
            do {
                try rlm.write {
                    message.wasSeen = true
                }
            } catch {}
        }
    }
    
    static func getUnseenMessages() -> [RealmMessage] {
        let rlm = try! Realm()
        let messages = rlm.objects(RealmMessage.self).filter { !$0.wasSeen }
        return Array(messages)
    }
}
