//
//  MISUWatchConnector.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 16.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import CoreBluetooth

final class MISUWatchConnector {
    
    private let ycpManager = YCProductManager.shared
    
    init() {
        ycpManager.connectionDelegate = self
        ycpManager.ycpDelegate = self
    }
    
    func connect(_ device: MISUWatch) {
        KeyStore.saveValue(true, for: .didConnectWatchOnce)
        ycpManager.connect(device: device.cbPeripheral)
    }
}

extension MISUWatchConnector: YCProductDelegate, YCPConnectingDelegate {
    func willStartScanning() {}
    
    func didUpdateScanning(devices: [CBPeripheral]) {}
    
    func willStartConnecting() {}
    
    func didEndConnecting(succes: Bool, descrition: String) {}
}
