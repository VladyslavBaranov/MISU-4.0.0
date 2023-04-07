//
//  GroupsDataManager.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 26.11.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation



class FamilyGroupManager: ObservableObject {
    @Published var group: GroupModel? = nil
    @Published var invites: [GroupInviteModel] = []
    
    static let shared = FamilyGroupManager()
    private init() { }
}

extension FamilyGroupManager {
    func loadAll() {
        loadGroups()
        loadInivites()
    }
    
    func loadGroups() {
        print("FamilyGroupManager 1")
        GroupsManager.shared.getAll { success, error in
            print("FamilyGroupManager 2")
            if let success = success {
                DispatchQueue.main.async {
                    self.group = success.first
                }
            }
            
            if let er = error {
                print("FamilyGroupManager loadGroups error: \(er.statusCode) \(er.message)")
            }
        }
    }
    
    func loadInivites() {
        GroupsManager.shared.getAllInvites { success, error in
            if let invites = success {
                DispatchQueue.main.async {
                    self.invites = invites
                }
            }
            
            if let er = error {
                print("FamilyGroupManager loadInivites error: \(er.statusCode) \(er.message)")
            }
        }
    }
    
    func deleteCurrentGroup() {
        guard let gId = group?.id else { return }
        GroupsManager.shared.delete(groupId: gId) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.clearLocalData()
                }
            }
            
            if let er = error {
                print("FamilyGroupManager deleteCurrentGroup error: \(er.statusCode) \(er.message)")
            }
        }
    }
    
    func leaveCurrentGroup() {
        GroupsManager.shared.leaveGroup { success, error in
            if success {
                DispatchQueue.main.async {
                    self.clearLocalData()
                }
            }
            
            if let er = error {
                print("FamilyGroupManager leaveCurrentGroup error: \(er.statusCode) \(er.message)")
            }
        }
    }
    
    func deleteFromCurrentGroup(inviteId: Int) {
        GroupsManager.shared.delete(inviteId: inviteId) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.loadInivites()
                }
            }
            
            if let er = error {
                print("FamilyGroupManager delete invite error: \(er.statusCode) \(er.message)")
            }
        }
    }
    
    func deleteFromCurrentGroup(userId: Int) {
        guard let gId = group?.id else { return }
        GroupsManager.shared.delete(userId: userId, fromGroup: gId) { success, error in
            if let newGroup = success {
                DispatchQueue.main.async {
                    self.group = newGroup
                }
            }
            
            if let er = error {
                print("FamilyGroupManager delete user error: \(er.statusCode) \(er.message)")
            }
        }
    }
    
    func inviteToGroup(phoneNum: String, completion: @escaping (_ error: HandledErrorModel?)->()) {
        print("FamilyGroupManager inviteToGroup")
        GroupsManager.shared.inviteV2(phoneNum) { success, error in
            print("FamilyGroupManager inviteToGroup")
            if let invite = success {
                DispatchQueue.main.async {
                    self.invites.insert(invite, at: 0)
                }
            }
            
            if let er = error {
                print("FamilyGroupManager inviteToGroup error: \(er.statusCode) \(er.message)")
            }
            
            completion(error)
        }
    }
    
//    func replyToInvite(_ invite: GroupInviteModel, accept: Bool) {
//        GroupsManager.shared.replyToInvite(invite, accept: accept) { success, error in
//            if let invite = success {
//                DispatchQueue.main.async {
//                    self.invitesForMe.insert(invite, at: 0)
//                }
//            }
//
//            if let er = error {
//                print("FamilyGroupManager leaveCurrentGroup error: \(er.statusCode) \(er.message)")
//            }
//        }
//    }
    
    func clearLocalData() {
        self.group = nil
        self.invites = []
    }
}
