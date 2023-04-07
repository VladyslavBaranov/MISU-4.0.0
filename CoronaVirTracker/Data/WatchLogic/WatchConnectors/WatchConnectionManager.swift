//
//  WatchConnectionManager.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 19.08.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import CoreBluetooth
import TrusangBluetooth

enum WatchType {
    case MISU, Apple, Trusang, none
}

protocol WatchConnectionManagerDelegate: AnyObject {
    func didDiscoverDevices(_ devices: [AbstractWatch])
}

class WatchConnectionManager {
    
    var foundWatches: [AbstractWatch] = []
    
    let ycpManager = YCProductManager.shared
    let trusangManager = TrusangManager.shared
    
    weak var delegate: WatchConnectionManagerDelegate!
    
    static let shared = WatchConnectionManager()
    
    private init() {
        ycpManager.ycpDelegate = self
        ycpManager.connectionDelegate = self
        trusangManager.connectionDelegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(performLogoutClearup),
            name: NotificationManager.shared.notificationName(for: .didLogout),
            object: nil
        )
    }
    
    @objc func performLogoutClearup() {
        guard let watch = WatchConnectionManager.shared.currentWatch() else { return }
        watch.disconnect(using: self)
    }
    
    func connect() {
        
    }
    
}

extension WatchConnectionManager {
    
    func currentWatch() -> AbstractWatch? {
        switch currentWatchType() {
        case .Apple:
            return AppleWatch()
        case .MISU:
            if let device = ycpManager.currentDevice {
                return MISUWatch(cbPeripheral: device)
            }
            return nil
        case .none:
            return nil
        case .Trusang:
            return nil
        }
    }
    
    private func currentWatchType() -> WatchType {
        if let isAppleWatch = UserDefaults.standard.value(forKey: "com.WH.MISU.apple-watch-is-connected") as? Bool {
            if isAppleWatch {
                return .Apple
            }
        }
        if ycpManager.currentDevice != nil {
            return .MISU
        }
        if TrusangManager.shared.connectedDeviceZHJ != nil {
            return .Trusang
        }
        return .none
    }
}

extension WatchConnectionManager: YCProductDelegate, YCPConnectingDelegate, TrusangConnectionDelegate {
    
    func didUpdateScanning(devices: [TrusangBluetooth.ZHJBTDevice]) {
        let watches = devices.map { TrusangWatch(device: $0) }
        delegate?.didDiscoverDevices(watches)
    }
    
    
    func didUpdateScanning(devices: [CBPeripheral]) {
        let watches = devices.map { MISUWatch(cbPeripheral: $0) }
        delegate?.didDiscoverDevices(watches)
    }
    
    func willStartScanning() {}
    
    func willStartConnecting() {
        
    }
    
    func didEndConnecting(succes: Bool, descrition: String) {
        guard let watch = currentWatch() else { return }
        NotificationManager.shared.post(.didConnectWatch, object: watch)
    }
    
    func didDiscoverDevice(_ device: CBPeripheral) {
        delegate.didDiscoverDevices([MISUWatch(cbPeripheral: device)])
    }
    
    func willDisconnect() {
        
    }
    
    func didDisconnect() {
        
    }
}
