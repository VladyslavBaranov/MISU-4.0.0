//
//  Notifications.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 23.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

enum NotificationType: String {
    
    case didHideLaunch = "com.MISU.didHideLaunch"
    
	case didLogout = "com.MISU.didLogOutNotification"
	case didLogin = "com.MISU.didLogInNotification"
    
    
	case didUpdateCurrentUser = "com.MISU.didUpdateCurrentUserNotification"
    case didUpdateIndicator = "com.MISU.didUpdateIndicator"
    case didUpdateAvatar = "com.MISU.didUpdateAvatar"
    
    case didForceIntensiveMonitoringToStop = "com.MISU.didForceIntensiveMonitoringToStop"
    
    case didConnectWatch = "com.MISU.didConnectWatch"
    case didFinishReadingHealthData = "com.MISU.didFinishReadingHealthData"
    
    case didUpdateChats = "com.MISU.didUpdateChats"
    
    case didConnectToNetwork = "com.MISU.didConnectToNetwork"
    
    case didDeleteMemberFromGroup = "com.MISU.didDeleteMemberFromGroup"
    
    case didSelectNewPeriodForGraph = "com.MISU.didSelectNewPeriodForGraph"
    
    case willBeginTestableAction = "com.MISU.willBeginTestableAction"
    
    case didChangeUserCountry = "com.MISU.didChangeUserCountry"
}

extension Notification.Name {
    
    static let didHideLaunch = "com.MISU.didHideLaunch"
	
	// User Management
	static let didLogoutNotification = "com.MISU.didLogOutNotification"
	static let didLogInNotification = "com.MISU.didLogInNotification"
	static let didUpdateCurrentUser = "com.MISU.didUpdateCurrentUserNotification"
    static let didUpdateAvatar = "com.MISU.didUpdateAvatar"
    static let didChangeUserCountry = "com.MISU.didChangeUserCountry"
    
    // Indicator management
    static let didUpdateIndicator = "com.MISU.didUpdateIndicator"
    
    static let didForceIntensiveMonitoringToStop = "com.MISU.didForceIntensiveMonitoringToStop"
    
    // Watch Management
    static let didConnectWatch = "com.MISU.didConnectWatch"
    static let didFinishReadingHealthData = "com.MISU.didFinishReadingHealthData"
    
    static let didUpdateChats = "com.MISU.didUpdateChats"
    
    static let didConnectToNetwork = "com.MISU.didConnectToNetwork"
    
    static let didDeleteMemberFromGroup = "com.MISU.didDeleteMemberFromGroup"
    
    static let didSelectNewPeriodForGraph = "com.MISU.didSelectNewPeriodForGraph"
    
    static let willBeginTestableAction = "com.MISU.willBeginTestableAction"
    
    
}

final class NotificationManager {
	
	static let shared = NotificationManager()
	
	func post(_ type: NotificationType) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(Notification(name: Notification.Name(type.rawValue)))
        }
	}
	
	func notificationName(for type: NotificationType) -> Notification.Name {
		Notification.Name(type.rawValue)
	}
    
    func post(_ type: NotificationType, object: Any?) {
        NotificationCenter.default.post(name: Notification.Name(type.rawValue), object: object)
    }
}
