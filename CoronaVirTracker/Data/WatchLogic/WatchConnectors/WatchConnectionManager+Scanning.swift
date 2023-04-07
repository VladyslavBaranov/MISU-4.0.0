//
//  WatchConnectionManager+Scanning.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 16.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

extension WatchConnectionManager {
    func scan() {
        ycpManager.scanningDevices()
        // trusangManager.scanningDevices()
    }
}
