//
//  HealthIndicator.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 26.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import HealthKit

enum __HealthIndicatorType: Int {
	
	case sleep = 0
	case activity = 1
	case pressure = 2
	case heartrate = 3
	case ecg = 4
	case sugar = 5
	case insuline = 6
	case oxygen = 7
	case temperature = 8
	
	func stringValue() -> String {
		switch self {
		case .sleep:
			return locStr("hc_str_2")
		case .activity:
			return "Активність"
		case .pressure:
			return locStr("hc_str_4")
		case .heartrate:
			return locStr("hc_str_6")
		case .ecg:
			return "ЕКГ"
		case .sugar:
			return locStr("hc_str_5")
		case .insuline:
			return "Інсулін"
		case .oxygen:
			return locStr("hc_str_7")
		case .temperature:
			return locStr("hc_str_8")
		}
	}
	
	func iconName() -> String {
		switch self {
		case .sleep:
			return "sleep"
		case .activity:
			return "steps"
		case .pressure:
			return "blood-pressure"
		case .heartrate:
			return "heart-rate"
		case .ecg:
			return "ecg"
		case .sugar:
			return "blood-sugar"
		case .insuline:
			return "insuline"
		case .oxygen:
			return "oxygen"
		case .temperature:
			return "temperature"
		}
	}
	
	func unitString() -> String {
		switch self {
		case .pressure:
			return locStr("unit_pressure")
		case .heartrate:
			return locStr("unit_heart")
		case .sugar:
			return locStr("unit_insuline")
		case .insuline:
			return locStr("unit_insuline")
		case .oxygen:
			return "%"
		case .temperature:
			return "°C"
		default:
			fatalError()
		}
	}
    
    func toEnum() -> HealthParamsEnum {
        switch self {
        case .sleep:
            fatalError()
        case .activity:
            fatalError()
        case .pressure:
            return .pressure
        case .heartrate:
            return .heartBeat
        case .ecg:
            fatalError()
        case .sugar:
            return .sugar
        case .insuline:
            return .insuline
        case .oxygen:
            return .bloodOxygen
        case .temperature:
            return .temperature
        }
    }
}
