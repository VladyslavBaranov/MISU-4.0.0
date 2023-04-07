//
//  WatchReadingManager.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 12.12.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

final class WatchReadingManager {
    
    private var watch: AbstractWatch?
    
    private init() {}
    
    static let shared = WatchReadingManager()
    
    func initiate() {
        watch = WatchConnectionManager.shared.currentWatch()
    }
    
}

private extension WatchReadingManager {
    
}
