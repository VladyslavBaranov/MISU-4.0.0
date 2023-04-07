//
//  AppleWatch.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 03.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

class AppleWatch: AbstractWatch {
	
	override func getName() -> String {
		return "Apple Watch (Health Kit)"
	}
    
    override func getBatteryLevel() -> Int {
        -1
    }
    
	override func connect(using manager: WatchConnectionManager) {
        if let ycpConnectedDevice = YCProductManager.shared.currentDevice {
            YCProductManager.shared.disconnect(device: ycpConnectedDevice)
        }
        if let trusangDevice = TrusangManager.shared.connectedDeviceCB {
            TrusangManager.shared.disconnect(device: trusangDevice)
        }
        
		UserDefaults.standard.set(true, forKey: "com.WH.MISU.apple-watch-is-connected")
        
        NotificationManager.shared.post(.didConnectWatch, object: self)
	}
    
	override func isConnected() -> Bool {
		guard let bool = UserDefaults.standard.value(forKey: "com.WH.MISU.apple-watch-is-connected") as? Bool else {
			return false
		}
		return bool
	}
    
    override func disconnect(using manager: WatchConnectionManager) {
        UserDefaults.standard.set(false, forKey: "com.WH.MISU.apple-watch-is-connected")
    }
}
