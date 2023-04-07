//
//  TrusangeWatch.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 03.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import TrusangBluetooth

class TrusangWatch: AbstractWatch {
	var device: ZHJBTDevice
	
	init(device: ZHJBTDevice) {
		self.device = device
	}
	
	override func getName() -> String {
		return device.name
	}
    
	override func getBatteryLevel() -> Int {
		TrusangManager.shared.devicePow ?? 0
	}
    
	override func isConnected() -> Bool {
        guard let device = TrusangManager.shared.connectedDeviceZHJ else { return false }
		return self.device.name == device.name
	}
    
    override func connect(using manager: WatchConnectionManager) {
        guard let peripheral = device.peripheral else { return }
        UserDefaults.standard.removeObject(forKey: "com.WH.MISU.apple-watch-is-connected")
        manager.trusangManager.connect(device: peripheral)
    }
    
    override func disconnect(using manager: WatchConnectionManager) {
        manager.trusangManager.disconnect(device: device.peripheral)
    }
}
