//
//  RealmImage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import RealmSwift

class RealmImage: Object {
    
    @Persisted var url: String
    @Persisted var data: Data?
    @Persisted var expirationDate: Date
    
    var isExpired: Bool {
        expirationDate < Date()
    }
    
    static func save(_ image: UIImage, for url: String) {
        let realm = try! Realm()
        let candidateImg = realm.objects(RealmImage.self).where({ $0.url == url }).first
        if candidateImg == nil {
            let img = RealmImage()
            img.data = image.jpegData(compressionQuality: 1)
            img.url = url
            img.expirationDate = Date().addingTimeInterval(3600)
            do {
                try realm.write {
                    realm.add(img)
                }
            } catch {}
        } else {
            do {
                try realm.write {
                    candidateImg!.data = image.jpegData(compressionQuality: 1)
                }
            } catch {}
        }
    }
    
    static func getImage(for url: String) -> RealmImage? {
        let realm = try! Realm()
        return realm.objects(RealmImage.self).where { $0.url == url }.first
    }
    
    static func clearExpiredImages() {
        let realm = try! Realm()
        let expired = realm.objects(RealmImage.self).filter { $0.isExpired }
        for img in expired {
            do {
                try realm.write {
                    realm.delete(img)
                }
            } catch {}
        }
    }
    
    static func clear() {
        let realm = try! Realm()
        let expired = realm.objects(RealmImage.self)
        for img in expired {
            do {
                try realm.write {
                    realm.delete(img)
                }
            } catch {}
        }
    }
    
    static func log() {
        let rlm = try! Realm()
        let objc = rlm.objects(RealmImage.self)
        // for obj in objc {
            // print(obj.url, obj.data?.count)
        // }
    }
}
