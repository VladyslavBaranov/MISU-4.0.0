//
//  RealmUser.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUserModel: Object {
    
    enum Update {
        case name(String)
        case birthDate(Date)
        case gender(Gender)
        case height(Double)
        case weight(Double)
    }
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userData: Data?
    @Persisted var isSync: Bool
    
    func save() {
        guard let realm = try? Realm() else { return }
        let models = realm.objects(RealmUserModel.self).map { $0.id }
        if models.contains(id) {
            let model = realm.objects(RealmUserModel.self).where { $0.id == self.id }.first
            do {
                try realm.write {
                    model?.userData = self.userData
                }
            } catch {}
        } else {
            do {
                try realm.write {
                    realm.add(self)
                }
            } catch {}
        }
    }
    
    static func getCurrent() -> RealmUserModel? {
        guard let realm = try? Realm() else { return nil }
        return realm.objects(RealmUserModel.self).where { $0.id == KeyStore.getIntValue(for: .currentUserId) }.first
    }
    
    func model() -> UserModel? {
        guard let data = userData else { return nil }
        return try? JSONDecoder().decode(UserModel.self, from: data)
    }
    
    func update(_ update: Update) {
        let curModel = RealmUserModel.getCurrent()
        guard let data = curModel?.userData else { return }
        guard var user = try? JSONDecoder().decode(UserModel.self, from: data) else { return }
        
        switch update {
        case .name(let name):
            user.profile?.name = name
            updateCurrentUserWithParameter(["name": name])
        case .birthDate(let date):
            user.profile?.birthdayDate = date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            updateCurrentUserWithParameter(["birth_date": formatter.string(from: date)])
        case .gender(let gender):
            user.profile?.gender = gender
            updateCurrentUserWithParameter(["gender": gender.rawValue])
        case .height(let height):
            user.profile?.height = height
            updateCurrentUserWithParameter(["height": height])
        case .weight(let weight):
            user.profile?.weight = weight
            updateCurrentUserWithParameter(["weight": weight])
        }
       
        let realm = try! Realm()
        do {
            try realm.write {
                curModel?.userData = try? JSONEncoder().encode(user)
                curModel?.isSync = false
            }
        } catch {}
    }
    
    func ensureSync() {
        let realm = try! Realm()
        do {
            try realm.write { [weak self] in
                self?.isSync = true
            }
        } catch {}
    }
    
    static func getBy(id: Int) -> RealmUserModel? {
        let realm = try! Realm()
        return realm.objects(RealmUserModel.self).where { $0.id == id }.first
    }
    
    static func clear() {
        let realm = try! Realm()
        let objects = realm.objects(RealmUserModel.self)
        for object in objects {
            do {
                try realm.write {
                    realm.delete(object)
                }
            } catch {}
        }
    }
    
    private func updateCurrentUserWithParameter(_ parameter: Parameters) {
        guard let token = KeychainUtility.getCurrentUserToken() else { return }
        UserManager.shared.updateUser(
            token, params: parameter, files: []
        ) { result, error in
            if error == nil {
                DispatchQueue.main.async { [weak self] in
                    self?.ensureSync()
                }
            }
        }
    }
}
