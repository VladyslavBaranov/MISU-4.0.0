//
//  MenuMainPageState.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 08.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI
import RealmSwift

class MenuMainPageState: ObservableObject{
    private var lastUserUpdateWithAppDidBecomeActive = Date()
    
    @Published var isAdmin = false
    
    @Published var failedToLoadDate = false
    @Published var isUpdating = false
    
    var realmUserModel: RealmUserModel?
    @Published var currentUser: UserModel?
    
    @Published var groupMembers: [UserModel] = []
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadCurrentUser),
            name: NotificationManager.shared.notificationName(for: .didLogin),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onAppear),
            name: NotificationManager.shared.notificationName(for: .didConnectToNetwork),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onAppear),
            name: NotificationManager.shared.notificationName(for: .didDeleteMemberFromGroup),
            object: nil
        )
    }
    
    @objc func onAppear() {
        loadCurrentUser()
        loadGroup()
    }
    
    @objc func appDidBecomeActive() {
        let date = Date()
        guard lastUserUpdateWithAppDidBecomeActive.distance(to: date) > 10 else { return }
        loadCurrentUser()
        loadGroup()
        lastUserUpdateWithAppDidBecomeActive = Date()
    }
    
    private func loadGroup() {
        
        isUpdating = true
        if let groupData = RealmJSON.retreive(for: .group) {
            if let group = try? JSONDecoder().decode(GroupModel.self, from: groupData) {
                groupMembers = group.allMembers
                isAdmin = group.isCurrentUserCreator
            }
        }
        
        GroupsManager.shared.getAll { success, error in
            guard let group = success?.first else { return }
            DispatchQueue.main.async { [ weak self] in
                self?.failedToLoadDate = error != nil
                self?.isUpdating = false
                self?.groupMembers = group.allMembers
                self?.isAdmin = group.isCurrentUserCreator
                if let data = try? JSONEncoder().encode(group) {
                    RealmJSON.write(data, for: .group)
                }
            }
        }
    }
    
    @objc func loadCurrentUser() {
        isUpdating = true
        realmUserModel = RealmUserModel.getCurrent()
        UserManager.shared.getCurrentWithRealm { [weak self] result, error in
            self?.failedToLoadDate = error != nil
            self?.isUpdating = false
            if result != nil {
                self?.currentUser = result
            }
        }
    }
}
