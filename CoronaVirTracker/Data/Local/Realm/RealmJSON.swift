//
//  RealmJSON.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import RealmSwift


class RealmJSON: Object {
    
    enum DataType: Int {
        case group = 0
        case partners = 1
        case assistant = 2
        case chatList = 3
    }
    
    @Persisted(primaryKey: true) var type: Int
    @Persisted var rawJson: Data
    
    static func retreive(for type: DataType) -> Data? {
        let realm = try! Realm()
        return realm.objects(RealmJSON.self).where { $0.type == type.rawValue }.first?.rawJson
    }
    
    static func write(_ data: Data, for type: DataType) {
        let realm = try! Realm()
        if let firstObject = realm.objects(RealmJSON.self).where({ $0.type == type.rawValue }).first {
            do {
                try realm.write {
                    firstObject.rawJson = data
                }
            } catch {}
        } else {
            let obj = RealmJSON()
            obj.type = type.rawValue
            obj.rawJson = data
            do {
                try realm.write {
                    realm.add(obj)
                }
            } catch {}
        }
    }
    
    static func clear() {
        let realm = try! Realm()
        let expired = realm.objects(RealmJSON.self)
        for img in expired {
            do {
                try realm.write {
                    realm.delete(img)
                }
            } catch {}
        }
    }
}
