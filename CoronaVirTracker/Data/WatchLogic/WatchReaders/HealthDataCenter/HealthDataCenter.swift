//
//  HealthDataCenter.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 07.01.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import Foundation

final class HealthDataCenter {
    
    private let appleWatchReader = AppleWatchDataReader()
    
    var pressureIndicators: [_HealthIndicator] = [] {
        didSet {
            IndicatorManager.shared.uploadIndicators(pressureIndicators, type: .pressure)
        }
    }
    
    var heartrateIndicators: [_HealthIndicator] = [] {
        didSet {
            IndicatorManager.shared.uploadIndicators(heartrateIndicators, type: .heartrate)
        }
    }
    
    var temperatureIndicators: [_HealthIndicator] = [] {
        didSet {
            IndicatorManager.shared.uploadIndicators(temperatureIndicators, type: .temperature)
        }
    }
    
    var oxygenIndicators: [_HealthIndicator] = [] {
        didSet {
            IndicatorManager.shared.uploadIndicators(oxygenIndicators, type: .oxygen)
        }
    }
    
    var sleepData: [_RealmSleepIndicatorPhase] = []
    
    static let shared = HealthDataCenter()
    
    private init() {
        appleWatchReader.delegate = self
    }
    
    func execute() {
        guard let watch = WatchConnectionManager.shared.currentWatch() else { return }
        if watch is AppleWatch {
            appleWatchReader.execute()
        } else if watch is MISUWatch {
            YCProductManager.shared.updateAllData()
        }
    }
    
}

extension HealthDataCenter: WatchDataReaderDelegate {
    
    func didFinishReadingSleepData(_ reader: WatchDataReader) {
        sleepData = (reader as? AppleWatchDataReader)?.sleepData ?? []
        let sleepRecord = RealmSleepIndicator(sleepData)
        sleepRecord.save()
    }
    
    func didFinishReadingData(_ reader: WatchDataReader) {
        pressureIndicators = reader.pressureIndicators.rawArray
        heartrateIndicators = reader.heartrateIndicators.rawArray
        temperatureIndicators = reader.temperatureIndicators.rawArray
        oxygenIndicators = reader.oxygenIndicators.rawArray
    }
}
