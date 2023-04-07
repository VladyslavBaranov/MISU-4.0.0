//
//  HealthIndicatorContainer.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 06.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import YCProductSDK

final class _HealthIndicator {
    var type: __HealthIndicatorType = .activity
    var value: Double = 0.0
    var additionalValue: Double? = 0.0
    var date: Date = Date()
    
    init() {
    }
    
    init(_ paramModel: HealthParameterModel) {
        if let value = paramModel.value {
            self.value = Double(value)
        }
        if let additionalValue = paramModel.additionalValue {
            self.additionalValue = Double(additionalValue)
        }
        if let date = paramModel.date?.toDate() {
            self.date = date
        }
    }
    
    init(_ ycPressure: YCHealthDataBloodPressure) {
        self.type = .pressure
        value = Double(ycPressure.systolicBloodPressure)
        additionalValue = Double(ycPressure.diastolicBloodPressure)
        date = Date(timeIntervalSince1970: TimeInterval(ycPressure.startTimeStamp))
    }
    
    init(_ ycHeart: YCHealthDataHeartRate) {
        self.type = .heartrate
        value = Double(ycHeart.heartRate)
        date = Date(timeIntervalSince1970: TimeInterval(ycHeart.startTimeStamp))
    }
    
    init(_ ycTemperature: YCHealthDataBodyTemperature) {
        self.type = .temperature
        value = Double(ycTemperature.temperature)
        date = Date(timeIntervalSince1970: TimeInterval(ycTemperature.startTimeStamp))
    }
    
    init(_ ycOxygen: YCHealthDataBloodOxygen) {
        self.type = .oxygen
        value = Double(ycOxygen.bloodOxygen)
        date = Date(timeIntervalSince1970: TimeInterval(ycOxygen.startTimeStamp))
    }
    
    func tpRealmModel() -> RealmIndicator {
        let rlm = RealmIndicator()
        rlm.value = value
        rlm.additionalValue = additionalValue
        rlm.date = date
        return rlm
    }
    
    func toHPModel() -> HealthParameterModel {
        var model = HealthParameterModel()
        model.value = Float(value)
        if let additionalValue = additionalValue {
            model.additionalValue = Float(additionalValue)
        }
        model.date = date.getTimeString()
        return model
    }
}

final class __HealthIndicatorArray {
	let indicatorType: __HealthIndicatorType
    private(set) var rawArray: [_HealthIndicator] = []
	
	var count: Int {
		rawArray.count
	}
	
	init(indicatorType: __HealthIndicatorType) {
		self.indicatorType = indicatorType
	}
	
	func append(_ indicator: _HealthIndicator) {
		rawArray.append(indicator)
	}
	
	func latest() -> _HealthIndicator? {
		rawArray.last
	}
}
