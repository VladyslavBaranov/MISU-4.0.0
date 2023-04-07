//
//  UserSettings.swift
//  WatchVPN
//
//  Created by Dmytro Kruhlov on 01.08.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

class UserSettings {
    static var timeToUpdate = KeychainUtils.getSharedDeviceUpdateTime() ?? 60
    static var currentUserToken: String? = KeychainUtils.getSharedCurrentUserToken()
    static var currentDeviceName: String? = KeychainUtils.getSharedDeviceName()
    
    static func update() {
        timeToUpdate = KeychainUtils.getSharedDeviceUpdateTime() ?? timeToUpdate
        currentUserToken = KeychainUtils.getSharedCurrentUserToken() ?? currentUserToken
        currentDeviceName = KeychainUtils.getSharedDeviceName() ?? currentDeviceName
    }
}
