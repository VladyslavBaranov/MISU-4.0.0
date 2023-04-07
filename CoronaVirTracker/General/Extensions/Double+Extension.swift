//
//  Double+Extension.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 20.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

extension Int {
    func getDurationString() -> String {
        let deepHours = self / 3600
        let deepMins = (self / 60) % 60
        let deepMinsString = deepMins < 10 ? "0\(deepMins)" : "\(deepMins)"
        return "\(deepHours) h \(deepMinsString) min"
    }
}

extension Double {
    static func getPercent(min: Double, max: Double, target: Double) -> Double {
        let k = 1 / (max - min)
        let b = -min / (max - min)
        return k * target + b
    }
    
    func isBetween(_ low: Double, _ high: Double) -> Bool {
        return self >= low && self <= high
    }
}

extension TimeInterval {
    func getDurationString() -> String {
        let hours = Int(self / 3600)
        let mins = Int((self / 60)) % 60
        return "\(hours) h \(mins) min"
    }
}
