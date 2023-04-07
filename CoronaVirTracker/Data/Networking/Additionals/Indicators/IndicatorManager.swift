//
//  IndicatorManager.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 04.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

final class IndicatorManager {
	
	static let shared = IndicatorManager()
	
	private init() {}
    
    func uploadIndicators(_ indicators: [_HealthIndicator], type: __HealthIndicatorType) {
        
        var model = ListHParameterModel()
        switch type {
        case .pressure:
            model.bloodPressure = indicators.map { $0.toHPModel() }
        case .heartrate:
            model.bloodPressure = indicators.map { $0.toHPModel() }
        case .sugar:
            model.sugar = indicators.map { $0.toHPModel() }
        case .oxygen:
            model.bloodOxygen = indicators.map { $0.toHPModel() }
        case .temperature:
            model.temperature = indicators.map { $0.toHPModel() }
        default:
            break
        }
        
        HealthParamsManager.shared.writeListHParams(
            model: model
        ) { success, error in
            print("@UPLOAD SUCCESS")
        }
    }
	
    func uploadBulk(_ bulk: _UploadServerIndicatorsBulk, completion: @escaping (Bool) -> ()) {
        HealthParamsManager.shared.writeListHParams(
            model: .init(bulk)) { success, error in
                completion(success)
            }
	}
	
	func getBulk(
        for type: __HealthIndicatorType,
        period: HealthParamsEnum.StaticticRange = .year,
        completion: @escaping ([_HealthIndicator]) -> ()
    ) {
        
        HealthParamsManager.shared.getHealthParamsHistory(type: type.toEnum()) { result, error in
            if let result = result {
                var array: [_HealthIndicator] = []
                for indicator in result {
                    let ind = _HealthIndicator(indicator)
                    ind.type = type
                    array.append(ind)
                }
                completion(array)
            } else {
                completion([])
            }
        }
	}
    
    func getBulkV2(
        for type: __HealthIndicatorType,
        period: HealthParamsEnum.StaticticRange = .year,
        completion: @escaping ([_HealthIndicator]) -> ()
    ) {
        HealthParamsManager.shared.getStatictic(
            type: type.toEnum(),
            range: period
        ) { result, error in
            if let result = result {
                var array: [_HealthIndicator] = []
                for indicator in result {
                    let ind = _HealthIndicator(indicator)
                    ind.type = type
                    array.append(ind)
                }
                completion(array)
            } else {
                completion([])
            }
        }
    }
    
    func performServerDataImport() {
        
        let targetIndicators: [
            __HealthIndicatorType
        ] = [.pressure, .temperature, .heartrate]
        for type in targetIndicators {
            HealthParamsManager.shared.getStatictic(
                type: type.toEnum(), range: .year
            ) { result, error in
                if let result = result {
                    var arr: [RealmIndicator] = []
                    for indicator in result {
                        let rlm = indicator.toRealmModel()
                        rlm.indicatorTypeIntValue = type.rawValue
                        arr.append(rlm)
                    }
                    RealmIndicator.insertBulk(arr, type: type)
                }
            }
        }
    }
}

