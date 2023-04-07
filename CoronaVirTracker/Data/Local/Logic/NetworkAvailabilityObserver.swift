//
//  NetworkAvailabilityObserver.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 12.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Network
import UIKit

final class NetworkAvailabilityObserver {
    
    private var previousStatus: NWPath.Status?
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.MISU.NetworkObserver")
    
    static let shared = NetworkAvailabilityObserver()
    
    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.setStatus(path.status)
        }
        monitor.start(queue: queue)
    }
    
    func setStatus(_ status: NWPath.Status) {
        
        if let previousStatus = previousStatus {
            if previousStatus == .unsatisfied && previousStatus != status {
                NotificationManager.shared.post(.didConnectToNetwork)
            }
            self.previousStatus = status
        } else {
            self.previousStatus = status
        }
        
    }
}
