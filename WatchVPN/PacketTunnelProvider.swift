//
//  PacketTunnelProvider.swift
//  WatchVPN
//
//  Created by Dmytro Kruhlov on 26.01.2021.
//  Copyright © 2021 CVTCompany. All rights reserved.
//

import NetworkExtension
import TrusangBluetooth

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        super.startTunnel(options: options, completionHandler: completionHandler)
        // Add code here to start the process of connecting the tunnel.
        ImagesManager.shared.getBy(
            link: "### VPN IT IS ALIVE \(String(describing: UserSettings.timeToUpdate)) !!! ..."
        ) { (success, error) in }
        fetchData()
    }
    
    func fetchData() {
        UserSettings.update()
        WatchSinglManager.shared.scanDevices(seconds: 10)
        YCProductManager.shared.scanningDevices()
        
        // Do not use the NSTimer here that will not run in background
        
        let q_background = DispatchQueue.global(qos: .background)
        let delayInSeconds: Double = 60.0 * Double(UserSettings.timeToUpdate) // seconds
        let popTime = DispatchTime.now() +  DispatchTimeInterval.seconds(Int(delayInSeconds))
        ImagesManager.shared.getBy(link: "delayInSeconds: \(delayInSeconds)") { (success, error) in }
        
        q_background.asyncAfter(deadline: popTime) { [self] in
            // Fetch your data from server and generate local notification by using UserNotifications framework
            
            //ImagesManager.shared.getBy(link: "0000000000") { (success, error) in }
            
            fetchData()
        }
    }

    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
        //ImagesManager.shared.getBy(link: "### VPN wake \(String(describing: timeToUpdate)) !!! ...") { (success, error) in }
        //fetchData()
    }
}
