//
//  HealthKitAssistant.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 18.08.2021.
//  Copyright © 2021 CVTCompany. All rights reserved.
//

import Foundation
import HealthKit
import MapKit

// MARK: - HK Connections Protocol
protocol HealthKitConnectionDelegate {
    func beginHKConnecting()
    func endHKConnecting()
    func startedHKDataReading()
    func dataReadingProcess(percent: Float)
    func endedHKDataReading()
}


// MARK: - HealthKitAssistant
class HealthKitAssistant: WatchManager {
    private let keyUDefIsHK = "HKsa&dja$hAss^ista32nt3W%atch"
    
    override var isConnected: Bool {
        get { return UserDefaultsUtils.getBool(key: keyUDefIsHK) ?? false }
        set { UserDefaultsUtils.save(value: newValue, key: keyUDefIsHK) }
    }
    
    static let shared = HealthKitAssistant()
    var store = HKHealthStore()
    
    var connectDelegate: HealthKitConnectionDelegate?
    
    let quantityTypeIds: [HKQuantityTypeIdentifier: HKQuantityTypeIdStruct] = [
        .bodyTemperature: .init(
            identifier: .bodyTemperature, unit: .degreeCelsius(), localizedTitle: locStr("hc_str_8")
        ),
        .bloodPressureDiastolic: .init(
            identifier: .bloodPressureDiastolic, unit: .millimeterOfMercury(),
            localizedTitle: locStr("mah_str_8")
        ),
        .bloodPressureSystolic: .init(
            identifier: .bloodPressureSystolic, unit: .millimeterOfMercury(),
            localizedTitle: locStr("mah_str_8")
        ),
        .heartRate: .init(
            identifier: .heartRate, unit:  HKUnit.count().unitDivided(by: .minute()),
            localizedTitle: locStr("mah_str_10")
        ),
        .oxygenSaturation: .init(
            identifier: .oxygenSaturation, unit: .percent(),
            localizedTitle: locStr("hc_str_7"), multiplier: 100
        ),
        .stepCount: .init(
            identifier: .stepCount, unit: .count(),
            localizedTitle: locStr("wm_str_4")
        )
    ]
    let categoryTypeIds: [HKCategoryTypeIdStruct] = [
        .init(
            identifier: .sleepAnalysis, unit: HKUnit.count(), localizedTitle: locStr("wm_str_3")
        )
    ]
    //HKObjectType.electrocardiogramType()
    
    private override init() {
        super.init()
        
        deviceModel = DeviceModel(name: DeviceType.AppleHK.key, date: Date(), dmac: "")
        
        quantityTypeIds[.bloodPressureSystolic]?.linkedQuantityType = quantityTypeIds[.bloodPressureDiastolic]
        quantityTypeIds[.bloodPressureDiastolic]?.linkedQuantityType = quantityTypeIds[.bloodPressureSystolic]
        
        if isConnected {
            checkAvailability()
        }
    }
    
    override func addUpdatingProcess() {
        super.addUpdatingProcess()
        if updatingProcessesCount == 1 {
            // print("HK startedHKDataReading ...")
            self.connectDelegate?.startedHKDataReading()
        }
    }
    
    override func removeUpdatingProcess() {
        super.removeUpdatingProcess()
        self.connectDelegate?.dataReadingProcess(percent: calculateUpdatingProcessesPercent())
        if updatingProcessesCount == 0 {
           // print("HK endedHKDataReading ...") HD
            self.connectDelegate?.endedHKDataReading()
        }
    }
    
    func calculateUpdatingProcessesPercent() -> Float {
        let p: Float = 1 - Float(updatingProcessesCount)/Float(quantityTypeIds.count+categoryTypeIds.count)
        print("HK p~\(p) ...")
        if p < 0 { return 0 }
        if p > 1 { return 1 }
        return p
    }
}

// MARK: - HK Connections
extension HealthKitAssistant {
    /// Disconnects if was connected. Checks availability and asks permition if was disconnected
    func connectDisconnectActions() {
        connectDelegate?.beginHKConnecting()
        if isConnected {
            isConnected = false
            connectDelegate?.endHKConnecting()
        } else {
            checkAvailability()
        }
    }
    
    /// Checks if HKHealthStore is avalible on this device
    /// - Not avalible on iPad
    private func checkAvailability() {
        if HKHealthStore.isHealthDataAvailable() {
            print("$HK HealthData is Available ...")
            store = HKHealthStore()
            requestAccess()
        } else {
            // ModalMessagesController.shared.show(message: "Health Kit is unavailable on this device ...", type: .error)
            print("HK HealthData is NOT Available ...")
            connectDelegate?.endHKConnecting()
        }
    }
    
    /// Requests access to heakth data
    /// - bodyTemperature
    /// - bloodPressureDiastolic
    /// - bloodPressureSystolic
    /// - heartRate
    /// - oxygenSaturation
    /// - sleepAnalysis
    private func requestAccess() {
        var healthKitTypesToRead: Set<HKObjectType> = []
        
        quantityTypeIds.forEach { qid, qt in
            guard let hkType = HKObjectType.quantityType(forIdentifier: qid) else {
                print("HK HealthData dataType is NOT Available \(qt.idString) ...")
                connectDelegate?.endHKConnecting()
                return
            }
            healthKitTypesToRead.insert(hkType)
        }
        
        categoryTypeIds.forEach { ct in
            guard let hkType = HKObjectType.categoryType(forIdentifier: ct.identifier) else {
                print("HK HealthData dataType is NOT Available \(ct.idString) ...")
                connectDelegate?.endHKConnecting()
                return
            }
            healthKitTypesToRead.insert(hkType)
        }
        
        store.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) in
            self.isConnected = success
            self.connectDelegate?.endHKConnecting()
            if success {
                self.saveDeviceConnection()
                self.getAllHKData()
                print("HK requestAuthorization \(success)")
            }
            
            if let er = error {
                print("HK requestAuthorization ERROR: \(er.localizedDescription)")
            }
        }
    }
}


// MARK: - Health Data getting
extension HealthKitAssistant {
    override func updateAllData() {
        getAllHKData()
    }
    
    func getAllHKData() {
        quantityTypeIds.values.forEach { qType in
            addUpdatingProcess()
            getQuantityData(forIdentifier: qType) {
                self.removeUpdatingProcess()
            }
        }
        categoryTypeIds.forEach { cType in
            addUpdatingProcess()
            getCategoryData(forIdentifier: cType) {
                self.removeUpdatingProcess()
            }
        }
        
        //retrieveSleepAnalysis()
    }
    
    public func getQuantityData(forIdentifier identifier: HKQuantityTypeIdStruct,
                                predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: Date().previous(count: 7), end: Date(), options: []),
                                _ completion: @escaping FinishCompletion) {
        guard let sampleType = HKSampleType.quantityType(forIdentifier: identifier.identifier) else {
            print("HK \(identifier.idString) ERROR: Unable to get on this device")
            completion()
            return
        }
        
        getQuery(forIdentifier: identifier, sampleType: sampleType, predicate: predicate, completion)
    }
    
    public func getCategoryData(forIdentifier identifier: HKCategoryTypeIdStruct,
                                predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: Date().previous(count: 7), end: Date(), options: []),
                                _ completion: @escaping FinishCompletion) {
        
        guard let sampleType = HKSampleType.categoryType(forIdentifier: identifier.identifier) else {
            print("HK \(identifier.idString) ERROR: Unable to get on this device")
            completion()
            return
        }
        
        getQuery(forIdentifier: identifier, sampleType: sampleType, predicate: predicate, completion)
    }
    
    func getQuery(forIdentifier identifier: HKQuantityTypeIdStruct,
                  sampleType: HKQuantityType,
                  predicate: NSPredicate? = nil,
                  limit: Int = HKObjectQueryNoLimit,
                  sortDescriptors: [NSSortDescriptor]? = nil,
                  _ completion: @escaping FinishCompletion) {
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { sampleQuery, hkSamples, error in
            print(">>>>>>>>>>>>>>>>>>>>>>> HK \(identifier.idString) <<<<<<<<<<<<<<<<<<<<<<<")
            
            if let hks = hkSamples {
                identifier.samples = hks
                HealthDataController.shared.saveHealthParamsServer(healthParams: ListHParameterModel(dataStruct: identifier))
                
                print("$", hks)
            }
            
            if let er = error {
                print("HK \(identifier.idString) getQuery ERROR: \(er.localizedDescription)")
            }
            
            completion()
        }
        
        store.execute(query)
    }
    
    func getQuery(forIdentifier identifier: HKCategoryTypeIdStruct,
                  sampleType: HKCategoryType,
                  predicate: NSPredicate? = nil,
                  limit: Int = HKObjectQueryNoLimit,
                  sortDescriptors: [NSSortDescriptor]? = nil,
                  _ completion: @escaping FinishCompletion) {
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { sampleQuery, hkSamples, error in
            print(">>>>>>>>>>>>>>>>>>>>>>> HK \(identifier.idString) <<<<<<<<<<<<<<<<<<<<<<<")
            /*print("HK \(identifier.idString) SQ: \(sampleQuery)")
            print("HK \(identifier.idString) hkS: \(hkSamples?.count ?? -1) \(hkSamples?.first as Any) \(hkSamples?[safe: 1] as Any) \(hkSamples?.last as Any)")
            print("HK \(identifier.idString) ERROR: \(error?.localizedDescription ?? "nil")")
            if let frst = hkSamples?.last as? HKCategorySample {
                print("HK \(identifier.idString) \(frst)")
                print("HK \(identifier.idString) \(frst.sampleType)")
                print("HK \(identifier.idString) \(frst.startDate)")
                print("HK \(identifier.idString) \(frst.endDate)")
                print("HK \(identifier.idString) \(frst.device as Any)")
                print("HK \(identifier.idString) \(frst.value)")
            }*/
            
            if let hks = hkSamples {
                identifier.samples = hks
                identifier.convertAndSave()
            }
            
            if let er = error {
                print("HK \(identifier.idString) getQuery ERROR: \(er.localizedDescription)")
            }
            
            completion()
        }
        
        store.execute(query)
    }
}



// MARK: - Extensions



// MARK: - typealiases and ERRORs
extension HealthKitAssistant {
    
    // FIX: Add HKError enum and handle all errors in it
    typealias FinishCompletion = () -> Void
}




extension SleepPhaseModel {
    convenience init(from phase: HKCategorySample) {
        self.init()
        dateTime = phase.startDate.getTimeDateForRequest()
        duration = Calendar.current.dateComponents([.minute], from: phase.startDate, to: phase.endDate).minute
        pType = .init(from: HKCategoryValueSleepAnalysis(rawValue: phase.value) ?? .inBed)
        print("HК Sleep phase \(pType?.title ?? "nil") = \(HKCategoryValueSleepAnalysis(rawValue: phase.value)?.descriptor ?? "nil") \(duration ?? -1) \(dateTime ?? "nil") |: \(phase.startDate.getTimeDateForRequest()) \(phase.endDate.getTimeDateForRequest())")
    }
}



// MARK: - Convert params to [HealthParameterModel] extension for ListHParameterModel
extension ListHParameterModel {
    /// Initializer  for HKQuantityTypeIdStruct, also convert params to [HealthParameterModel] and saves to varibles pulse, bloodOxygen, bloodPressure, temperature
    init(dataStruct: HKQuantityTypeIdStruct) {
        switch dataStruct.identifier {
        case .heartRate:
            pulse = convertParams(dataStruct)
        case .bloodPressureSystolic:
            guard let pDias = dataStruct.linkedQuantityType else {
                print("HK HD ERROR: pressureSystolic doe's not have linked type pressureDiastolic ...")
                return
            }
            bloodPressure = convertParams(pressureSystolic: dataStruct, pressureDiastolic: pDias)
        case .bloodPressureDiastolic:
            guard let pSys = dataStruct.linkedQuantityType else {
                print("HK HD ERROR: pressureDiastolic doe's not have linked type pressureSystolic ...")
                return
            }
            bloodPressure = convertParams(pressureSystolic: pSys, pressureDiastolic: dataStruct)
        case .oxygenSaturation:
            bloodOxygen = convertParams(dataStruct)
        case .bodyTemperature:
            
            temperature = convertParams(dataStruct)
        default:
            return
        }
    }
    
    /// Converts [HKQuantitySample] from HKQuantityTypeIdStruct to [HealthParameterModel]
    /// - Returns: list of parameters - [HealthParameterModel]
    /// - if gets  bloodPressureDiastolic or bloodPressureSystolic than returns empty list and prints ERROR in console
    func convertParams(_ qHealthParams: HKQuantityTypeIdStruct) -> [HealthParameterModel] {
        if qHealthParams.identifier == .bloodPressureDiastolic || qHealthParams.identifier == .bloodPressureSystolic {
            print("HK HD ERROR: Wrong pressure converting! Use special method for pressure -> convertParams(pressureSystolic: HKQuantityTypeIdStruct, pressureDiastolic: HKQuantityTypeIdStruct) ...")
            return []
        }
        
        return qHealthParams.quantitySamples.map { sample in
            print("HK \(qHealthParams.idString) \(sample.sampleType)")
            print("HK \(qHealthParams.idString) \(sample.startDate)")
            print("HK \(qHealthParams.idString) \(sample.endDate)")
            
            let value = Float(sample.quantity.doubleValue(for: qHealthParams.unit)) * qHealthParams.multiplier
            
            print("HK \(qHealthParams.idString) \(value)")
            
            return .init(value: value,
                         additionalValue: nil,
                         date: sample.endDate)
        }
    }
    
    /// Converts pressure Systolic [HKQuantitySample] and Diastolic [HKQuantitySample] from HKQuantityTypeIdStruct to [HealthParameterModel]
    /// - Returns: list of parameters - [HealthParameterModel]
    /// - Special converter for pressure
    func convertParams(pressureSystolic: HKQuantityTypeIdStruct, pressureDiastolic: HKQuantityTypeIdStruct) -> [HealthParameterModel] {
        return pressureSystolic.quantitySamples.reduce(into: [HealthParameterModel]()) { result, pSysElement in
            guard let pDiasElement = pressureDiastolic.quantitySamples.first(
                where: {$0.endDate == pSysElement.endDate}) else { return }
            print("HK \(pressureSystolic.idString) \(pSysElement.startDate) \(pDiasElement.startDate)")
            print("HK \(pressureSystolic.idString) \(pSysElement.endDate) \(pDiasElement.endDate)")
            print("HK \(pressureSystolic.idString) \(pSysElement.quantity.doubleValue(for: pressureSystolic.unit)) \(pDiasElement.quantity.doubleValue(for: pressureDiastolic.unit))")
            
            let sValue = Float(pSysElement.quantity.doubleValue(for: pressureSystolic.unit))
            let dValue = Float(pDiasElement.quantity.doubleValue(for: pressureDiastolic.unit))
            
            print("HK \(pressureSystolic.idString) \(sValue) \(dValue)")
            
            result.append(.init(value: sValue,
                                additionalValue: dValue,
                                date: pSysElement.endDate))
        }
    }
}



// MARK: - Ext SleepPhaseType
extension SleepPhaseType {
    init(from: HKCategoryValueSleepAnalysis) {
        switch from {
        case .asleep:
            self = .light
        case .awake:
            self = .begin
        case .inBed:
            self = .light
        @unknown default:
            self = .light
        }
    }
}



// MARK: - HKCategoryValueSleepAnalysis Extension
extension HKCategoryValueSleepAnalysis {
    var descriptor: String {
        switch self {
        case .inBed:
            return "inBed"
        case .asleep:
            return  "asleep"
        case .awake:
            return  "awake"
        @unknown default:
            return  "unknown"
        }
    }
}
