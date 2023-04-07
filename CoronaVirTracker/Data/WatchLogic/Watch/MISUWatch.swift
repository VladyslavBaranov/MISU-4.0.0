//
//  MISUWatch.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 03.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import YCProductSDK
import CoreBluetooth

class MISUWatch: AbstractWatch {
	var cbPeripheral: CBPeripheral
	
	init(cbPeripheral: CBPeripheral) {
		self.cbPeripheral = cbPeripheral
	}
	
	override func getName() -> String {
		return cbPeripheral.name ?? "Unknown"
	}
    
	override func getBatteryLevel() -> Int {
		YCProductManager.shared.currentBatteryPower
	}
    
	override func isConnected() -> Bool {
		guard let device = YCProductManager.shared.currentDevice else { return false }
		return cbPeripheral.name == device.name
	}
    
    override func connect(using manager: WatchConnectionManager) {
        UserDefaults.standard.removeObject(forKey: "com.WH.MISU.apple-watch-is-connected")
        manager.ycpManager.connect(device: cbPeripheral)
    }
    
    override func disconnect(using manager: WatchConnectionManager) {
        manager.ycpManager.disconnect(device: cbPeripheral)
    }
}
