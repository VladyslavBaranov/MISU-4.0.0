//
//  HealthKitModels.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.07.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import HealthKit
import MapKit

// MARK: - Models
class HKTypeIdStruct {
    
    var localizedTitle: String = ""
    
    let unit: HKUnit
    var idString: String { return unit.unitString }
    var samples: [HKSample] = []
    
    init(unit un: HKUnit) {
        unit = un
    }
}

class HKQuantityTypeIdStruct: HKTypeIdStruct {
    let identifier: HKQuantityTypeIdentifier
    override var idString: String { return identifier.rawValue }
    
    var quantitySamples: [HKQuantitySample] = []
    override var samples: [HKSample] {
        didSet {
            quantitySamples = samples.reduce(into: [HKQuantitySample]()) { result, element in
                if let qs = element as? HKQuantitySample {
                    result.append(qs)
                }
            }
        }
    }
    
    /// Linked model for data that need few values: pressure (systolic, diastolic)
    var linkedQuantityType: HKQuantityTypeIdStruct? = nil
    
    /// Special multiplier for values to convert HealthKit data to MISU server side
    /// - Default value is 1
    /// - Oxygen saturation: 0-1 HK -> MISU: 0-100 = multiplier should be 100
    var multiplier: Float
    
    init(identifier id: HKQuantityTypeIdentifier, unit un: HKUnit, localizedTitle: String, multiplier mp: Float = 1) {
        identifier = id
        multiplier = mp
        super.init(unit: un)
        self.localizedTitle = localizedTitle
    }
}

class HKCategoryTypeIdStruct: HKTypeIdStruct {
    let identifier: HKCategoryTypeIdentifier
    override var idString: String { return identifier.rawValue }
    
    var categorySample: [HKCategorySample] = []
    override var samples: [HKSample] {
        didSet {
            categorySample = samples.reduce(into: [HKCategorySample]()) { result, element in
                if let qs = element as? HKCategorySample {
                    result.append(qs)
                }
            }
        }
    }
    
    init(identifier id: HKCategoryTypeIdentifier, unit un: HKUnit, localizedTitle: String) {
        identifier = id
        super.init(unit: un)
        self.localizedTitle = localizedTitle
    }
}

// MARK: - Convert HKCategoryType to specific Type
extension HKCategoryTypeIdStruct {
    /// Runs methods for converting, seves to server and in to HealthKitAssistant
    /// - converts samples of HKCategoryTypeIdStruct to specific Type
    /// - saves to server by using HealthDataController
    func convertAndSave() {
        switch identifier {
        case .sleepAnalysis:
            print("HK \(idString) convertAndSave")
            let sleepDict = convertSleep()
            HealthKitAssistant.shared.sleepHistory = sleepDict
            HealthDataController.shared.saveToServer(sleepList: sleepDict)
        default:
            print("HК HKCategoryTypeIdStruct convertAndSave ERROR: switch case is not provided for \(identifier)")
        }
    }
    
    func convertSleep() -> [SleepModel] {
        print("HK \(idString) convertSleep")
        var historicalSleep: [SleepModel] = []
        
        categorySample.sort { first, second in
            if first.startDate.compare(second.startDate) == .orderedAscending {
                return true
            }
            return false
        }
        
        /*categorySample.forEach { smpl in
            print("^^^ $$$ A \(smpl.startDate) \(smpl.endDate) \(HKCategoryValueSleepAnalysis(rawValue: smpl.value)?.descriptor ?? "nil") \(smpl.value)")
        }*/
        // var categorySmplID: [Int: [HKCategorySample]] = [:]
        // var lastId: Int = 0
        // var index = 0
        categorySample.forEach { value in
            
        }
        /*
        categorySmplID.forEach { key, values in
            guard let date = values.first?.startDate else { return }
            historicalSleep.append(.init(date: date, uId: -1))
            
            values.forEach { value in
                historicalSleep.last?.details.append(SleepPhaseModel(from: value))
            }
        }
        */
        return historicalSleep
    }
}

