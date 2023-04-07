//
//  LocalDataManager.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 23.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import RealmSwift

final class LocalDataManager {
	
	static let shared = LocalDataManager()
    
    func performActionsOnAppLaunch() {
        
        if KeychainUtility.getCurrentUserToken() == nil {
            RealmIndicator.clear()
            RealmUserModel.clear()
            RealmImage.clear()
            RealmJSON.clear()
        }
    }
	
	func performLogoutClearup() {
		
		_ = KeychainUtility.removeCurrentUserToken()
        performActionsOnAppLaunch()
        
	}
    
}
