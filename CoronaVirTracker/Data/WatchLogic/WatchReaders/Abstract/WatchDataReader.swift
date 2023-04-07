//
//  WatchDataReader.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 02.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

class WatchDataReader {
	var activityIndicators: __HealthIndicatorArray = .init(indicatorType: .activity)
	var temperatureIndicators: __HealthIndicatorArray = .init(indicatorType: .temperature)
	var heartrateIndicators: __HealthIndicatorArray = .init(indicatorType: .heartrate)
	var sugarIndicators: __HealthIndicatorArray = .init(indicatorType: .sugar)
    var oxygenIndicators: __HealthIndicatorArray = .init(indicatorType: .oxygen)
	
	// Do not use these 2 properties elsewhere outside this class and subclasses
	var systolicPressureIndicators: __HealthIndicatorArray = .init(indicatorType: .pressure)
	var diastolicPressureIndicators: __HealthIndicatorArray = .init(indicatorType: .pressure)
	
	var pressureIndicators: __HealthIndicatorArray = .init(indicatorType: .pressure)
	
	weak var delegate: WatchDataReaderDelegate!
}

protocol WatchDataReaderDelegate: AnyObject {
	func didFinishReadingData(_ reader: WatchDataReader)
    func didFinishReadingSleepData(_ reader: WatchDataReader)
}
