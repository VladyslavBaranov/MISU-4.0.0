//
//  AbstractWatch.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 16.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

class AbstractWatch {
    func getName() -> String { "" }
    func connect(using manager: WatchConnectionManager) {}
    func getBatteryLevel() -> Int { 0 }
    func isConnected() -> Bool { false }
    func disconnect(using manager: WatchConnectionManager) {}
}
