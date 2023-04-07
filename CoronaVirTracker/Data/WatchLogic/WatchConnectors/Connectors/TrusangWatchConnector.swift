//
//  TrusangWatchConnector.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 16.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import TrusangBluetooth
import CoreBluetooth

final class TrusangWatchConnector {
    
    private let trusangManager = TrusangManager.shared
    
    init() {
        trusangManager.connectionDelegate = self
    }
    
    func connect(_ device: TrusangWatch) {
        if let device = device.device.peripheral {
            trusangManager.connect(device: device)
        }
    }
}

extension TrusangWatchConnector: TrusangConnectionDelegate {
    func didUpdateScanning(devices: [TrusangBluetooth.ZHJBTDevice]) {}
    
    func willStartScanning() {}
    
    func didUpdateScanning(devices: [CBPeripheral]) {}
    
    func willStartConnecting() {}
    
    func didEndConnecting(succes: Bool, descrition: String) {}
}
