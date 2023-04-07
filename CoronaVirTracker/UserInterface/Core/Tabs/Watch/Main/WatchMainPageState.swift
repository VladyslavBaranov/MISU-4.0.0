//
//  WatchMainPageState.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 02.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

final class WatchMainPageState: ObservableObject {
	
	let appleWatchReader = AppleWatchDataReader()
    
    var pressureIndicators: [RealmIndicator] = []
    var heartrateIndicators: [RealmIndicator] = []
    var temperatureIndicators: [RealmIndicator] = []
    var oxygenIndicators: [RealmIndicator] = []
	
	init() {
		appleWatchReader.delegate = self
        
        if KeychainUtility.getCurrentUserToken() != nil {
            if WatchConnectionManager.shared.currentWatch() is AppleWatch {
                appleWatchReader.execute()
            }
            appleWatchReader.execute()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshIndicator(_:)),
            name: NotificationManager.shared.notificationName(for: .didUpdateIndicator),
            object: nil
        )
	}
    
    func refreshLocally(updaitingUI: Bool = false) {
        pressureIndicators = RealmIndicator.getIndicators(for: .pressure)
        heartrateIndicators = RealmIndicator.getIndicators(for: .heartrate)
        temperatureIndicators = RealmIndicator.getIndicators(for: .temperature)
        oxygenIndicators = RealmIndicator.getIndicators(for: .oxygen)
        
        DispatchQueue.main.async { [weak self] in
            if updaitingUI {
                self?.objectWillChange.send()
            }
        }
        
    }
}

extension WatchMainPageState: WatchDataReaderDelegate {
    func didFinishReadingSleepData(_ reader: WatchDataReader) {
    }
    
    func didFinishReadingData(_ reader: WatchDataReader) {
        DispatchQueue.main.async {
            RealmIndicator.insertBulk(reader.temperatureIndicators.rawArray, type: .temperature)
            RealmIndicator.insertBulk(reader.heartrateIndicators.rawArray, type: .heartrate)
            RealmIndicator.insertBulk(reader.pressureIndicators.rawArray, type: .pressure)
            
            self.refreshLocally()
            
            // self.uploadHealthDataToServer()
        }
    }
}

private extension WatchMainPageState {
    
    @objc func refreshIndicator(_ notification: Notification) {
        guard let type = notification.object as? __HealthIndicatorType else { return }
        switch type {
        case .pressure:
            pressureIndicators = RealmIndicator.getIndicators(for: .pressure)
        case .heartrate:
            heartrateIndicators = RealmIndicator.getIndicators(for: .heartrate)
        case .temperature:
            temperatureIndicators = RealmIndicator.getIndicators(for: .temperature)
        default:
            break
        }
        
        // uploadHealthDataToServer()
        
        objectWillChange.send()
    }
    
    func uploadHealthDataToServer() {
        var bulk = _UploadServerIndicatorsBulk()
        bulk.assign(pressureIndicators.filter { !$0.isSync }, type: .pressure)
        bulk.assign(temperatureIndicators.filter { !$0.isSync }, type: .temperature)
        
        guard !bulk.isEmpty() else { return }
        
        /*
        IndicatorManager.shared.uploadBulk(bulk) { [weak self] success in
            if success {
                // DispatchQueue.main.async { [weak self] in
                guard let sSelf = self else { return }
                for indicator in sSelf.pressureIndicators {
                    indicator.ensureSync()
                }
                for indicator in sSelf.temperatureIndicators {
                    indicator.ensureSync()
                }
                // }
            }
        }
         */
    }
}
