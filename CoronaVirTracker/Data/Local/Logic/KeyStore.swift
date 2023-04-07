//
//  KeyStore.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 07.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

struct KeyStore {
    
    enum Key: String {
        
        case token = "com.MISU.KeyStore.current.user.token"
        
        case currentUserId = "com.MISU.KeyStore.current.user.id"
        
        case didShowChatStart = "com.MISU.KeyStore.didShowChatStart"
        case didShowWatchStart = "com.MISU.KeyStore.didShowWatchStart"
        
        case didConnectWatchOnce = "com.MISU.KeyStore.didConnectWatchOnce"
        
        case userCountry = "com.MISU.KeyStore.userCountry"
        
        case subscriptionID = "com.misu.subscriptionid"
    }
    
    static func saveValue(_ value: Any, for key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func getIntValue(for key: Key) -> Int {
        UserDefaults.standard.value(forKey: key.rawValue) as? Int ?? -1
    }
    
    static func getBoolValue(for key: Key) -> Bool {
        UserDefaults.standard.value(forKey: key.rawValue) as? Bool ?? false
    }
    
    static func getStringValue(for key: Key) -> String? {
        UserDefaults.standard.value(forKey: key.rawValue) as? String
    }
    
    static func dropValue(for key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
