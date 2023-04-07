//
//  YCPHealthIndicator.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 19.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import YCProductSDK

enum YCPHealthIndicator: CaseIterable {
    case step, sleep, heartRate, bloodPressure, bloodOxygen, bodyTemperature
    
    var YCQDataType: YCQueryHealthDataType {
        switch self {
        case .step:
            return .step
        case .sleep:
            return .sleep
        case .heartRate:
            return .heartRate
        case .bloodPressure:
            return .bloodPressure
        case .bloodOxygen:
            return .bloodOxygen
        case .bodyTemperature:
            return .bodyTemperature
        }
    }
    
    var YCHDataClass: AnyClass {
        switch self {
        case .step:
            return YCHealthDataStep.self
        case .sleep:
            return YCHealthDataSleep.self
        case .heartRate:
            return YCHealthDataHeartRate.self
        case .bloodPressure:
            return YCHealthDataBloodPressure.self
        case .bloodOxygen:
            return YCHealthDataBloodOxygen.self
        case .bodyTemperature:
            return YCHealthDataBodyTemperature.self
        }
    }
}
