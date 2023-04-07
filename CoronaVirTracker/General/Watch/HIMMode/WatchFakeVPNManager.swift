//
//  WatchFakeVPNManager.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 25.01.2021.
//  Copyright © 2021 CVTCompany. All rights reserved.
//

import Foundation
import NetworkExtension
import TrusangBluetooth

typealias SuccessBoolCompletion = (Bool)->Void
typealias ConnectWatchCompletion = (_ success: Bool, _ error: String?)->Void
protocol WatchFakeVPNManagerDelegate {
    func gotVPNManager(manager: NETunnelProviderManager)
}

class WatchFakeVPNManager {
    static let shared = WatchFakeVPNManager()
    private init() {
        loadFromPrefs()
    }
    
    var delegate: WatchFakeVPNManagerDelegate? = nil
    var manager: NETunnelProviderManager? = nil
    
    var isConnected: Bool {
        manager?.connection.status == .connected
    }
    
    func startFakeWPN(completion: ConnectWatchCompletion? = nil) {
        // Test
        //saveMonitoringTime(1)
        
        var anyDevice = false
        if
            let deviceName = TrusangManager.shared.connectedDeviceZHJ?.name,
            !deviceName.isEmpty,
            KeychainUtility.saveToSharedDeviceName(deviceName)
        {
            anyDevice = true
        }
        
        if
            let deviceName = YCProductManager.shared.currentDevice?.name,
            !deviceName.isEmpty,
            KeychainUtility.saveToSharedDeviceName(deviceName)
        {
            anyDevice = true
        }
        
        if !anyDevice {
            completion?(false, NSLocalizedString("VPN Reconnect MISUWatch", comment: ""))
            return
        }
        
        guard let token = KeychainUtility.getCurrentUserToken(),
              KeychainUtility.saveToSharedCurrentUserToken(token), !token.isEmpty
        else {
            completion?(false, NSLocalizedString("VPN Try login again", comment: ""))
            return
        }
        
        loadFromPrefs { prfSuccess, prfError in
            if prfSuccess {
                self.removeVPNFromPrefs { remSucces, rmError in
                    if remSucces {
                        self.createNewAndRun(completion: completion)
                    } else {
                        completion?(remSucces, rmError)
                    }
                }
            } else {
                self.createNewAndRun(completion: completion)
            }
        }
    }
    
    private func createNewAndRun(completion: ConnectWatchCompletion?) {
        self.createNew { crSuccess, crError in
            if crSuccess {
                self.loadFromPrefs { sc, er in
                    if sc {
                        self.startVPN(completion: completion)
                    } else {
                        completion?(sc, er)
                    }
                }
            } else {
                completion?(crSuccess, crError)
            }
        }
    }
    
    private func createNew(completion: ConnectWatchCompletion? = nil) {
        let manager_ = makeManager()
        manager_.saveToPreferences { [self] error in
            print("### VPN create error \(String(describing: error))")
            if error == nil {
                manager = manager_
                print("### VPN Created new")
                completion?(true, nil)
                delegate?.gotVPNManager(manager: manager_)
            } else {
                print("### VPN save error \(String(describing: error))")
                completion?(false, error?.localizedDescription)
            }
        }
    }
    
    func loadFromPrefs(completion: ConnectWatchCompletion? = nil) {
        NETunnelProviderManager.loadAllFromPreferences { [self] managers, error in
            if let m = managers?.first {
                manager = m
                completion?(true, error?.localizedDescription)
                delegate?.gotVPNManager(manager: m)
            } else {
                completion?(false, error?.localizedDescription)
            }
        }
    }
    
    func stopAndRemove() {
        stopVPN()
        removeVPNFromPrefs()
    }
    
    private func stopVPN() {
        manager?.connection.stopVPNTunnel()
    }
    
    private func removeVPNFromPrefs(completion: ConnectWatchCompletion? = nil) {
        manager?.removeFromPreferences(completionHandler: { error in
            completion?(error == nil, error?.localizedDescription)
        })
    }
    
    private func startVPN(completion: ConnectWatchCompletion? = nil) {
        do {
            let optionsTest = [NEVPNConnectionStartOptionUsername: "MISU",
                               NEVPNConnectionStartOptionPassword: "password"
            ] as [String : NSObject]
            try manager?.connection.startVPNTunnel(options: optionsTest)
            print("### Started VPN tunnel message ...")
            completion?(true, nil)
        } catch {
            print("### Failed to start VPN tunnel message: \(error.localizedDescription)")
            completion?(false, error.localizedDescription)
        }
    }
    
    private func makeManager() -> NETunnelProviderManager {
        let manager = NETunnelProviderManager()
        manager.localizedDescription = "Secure VPN connection for MISUWatch"

        // Configure a VPN protocol to use a Packet Tunnel Provider
        let proto = NETunnelProviderProtocol()
        
        // This must match an app extension bundle identifier
        proto.providerBundleIdentifier = "com.WH.MISU.WatchVPN"
        
        // Replace with an actual VPN server address
        proto.serverAddress = "MISUWatch VPN"
        
        // Pass additional information to the tunnel
        proto.providerConfiguration = [:]
        
        manager.protocolConfiguration = proto

        // Enable the manager by default
        manager.isEnabled = true

        return manager
    }
    
    /// Default value is 60
    func saveMonitoringTime(_ time: Int?) {
        _ = KeychainUtility.saveToSharedDeviceUpdateTime(time ?? 60)
    }
}


//class NEPacketTunnelProviderTest: NEPacketTunnelProvider {
//    override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
//        print("### VPN IT IS ALIVE !!! ...")
//    }
//}
