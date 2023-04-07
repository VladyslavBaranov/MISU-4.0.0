//
//  HealthDataController.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 17.12.2021.
//  Copyright © 2021 CVTCompany. All rights reserved.
//

import Foundation

typealias HistoricalIndicators = [HealthParamsEnum.StaticticRange:[HealthParameterModel]]
typealias HistoricalIndicatorsByType = [HealthParamsEnum:HistoricalIndicators]
typealias SleepCompletion = (_ _sm: SleepModel?) -> Void


// MARK: - HealthData Deledates
@objc protocol HealthDataDeledate {}

@objc protocol SleepDataDeledate {
    @objc optional func sleepDataUpdated()
    @objc optional func sleepDataUpdated(error: String)
    
    @objc optional func sleepRecommendationsUpdated()
    @objc optional func sleepRecommendationsUpdated(error: String)
}

protocol IndicatorsDataDeledate {
    func indicatorUpdated(type tp: HealthParamsEnum, range: HealthParamsEnum.StaticticRange, data: [HealthParameterModel])
    func indicatorUpdatedWith(error: String, type tp: HealthParamsEnum, range: HealthParamsEnum.StaticticRange)
}



// MARK: - HealthData Controller
class HealthDataController {
    static let shared = HealthDataController()
    private init() {
        DispatchQueue.background {
            self.updateAllData()
        } completion: {
            
        }
    }
    
    var delegate: HealthDataDeledate?
    var sleepDelegate: SleepDataDeledate?
    var indicatorsDeledate: IndicatorsDataDeledate?
    
    var sleepRecommendations: [RecommendationSleepModel] = []
    /// Contains all sleep models by indexes
    /// - WARNING! Index starts from 1
    var sleepHistory: [Int:SleepModel] = [:]
    
    var indicatorsCachedUId: [Int:HistoricalIndicatorsByType] = [:]
    var indicators: HistoricalIndicatorsByType = {
        var ind = HistoricalIndicatorsByType()
        HealthParamsEnum.StaticticRange.allCases.forEach { r in
            HealthParamsEnum.allCases.forEach { hp in
                if ind[hp] == nil {
                    ind.updateValue([r:[]], forKey: hp)
                } else {
                    ind[hp]?.updateValue([], forKey: r)
                }
            }
        }
        return ind
    }()
    
    func nextSleepRecommendation(after: RecommendationSleepModel?) -> RecommendationSleepModel?{
        nil
    }
    
    func generateStartedHistoricalIndicatorsByType() -> HistoricalIndicatorsByType {
        var ind = HistoricalIndicatorsByType()
        HealthParamsEnum.StaticticRange.allCases.forEach { r in
            HealthParamsEnum.allCases.forEach { hp in
                if ind[hp] == nil {
                    ind.updateValue([r:[]], forKey: hp)
                } else {
                    ind[hp]?.updateValue([], forKey: r)
                }
            }
        }
        return ind
    }
}



// MARK: - Get Health Data
extension HealthDataController {
    /// Updates all health data types in HealthDataType enum from server
    func updateAllData() {
        HealthDataType.allCases.forEach {
            $0.updateData()
        }
    }
    
    /// Updates specific health data type in HealthDataType enum from server
    func update(_ healthData: HealthDataType) {
        healthData.updateData()
    }
    
    /// Updates HealthParamsEnum indicator from server by specific range
    /// - Data will saved in list indicators of HealthDataController
    /// - Does not send to delegate if data is the same
    func updateIndicator(type: HealthParamsEnum, range: HealthParamsEnum.StaticticRange) {
        HealthParamsManager.shared.getStatictic(type: type, range: range) { (paramsOp, errorOp) in
            if let pr = paramsOp, self.indicators[type]?[range] != pr {
                self.indicators[type]?.updateValue(pr, forKey: range)
                self.indicatorsDeledate?.indicatorUpdated(type: type, range: range, data: pr)
                // print("HD getStatictic: tp: \(type.nameVorRequest) r: \(range.rawValue) c: \(String(describing: paramsOp?.count))")
            }
            
            if let er = errorOp {
                // print("HD getStatictic tp: \(type.nameVorRequest) r: \(range.rawValue) ERROR: \(er.message)")
                self.indicatorsDeledate?.indicatorUpdatedWith(error: er.message, type: type, range: range)
            }
        }
    }
    
    /// Updates HealthParamsEnum indicator from server by specific range and for specific PROFILE id
    /// - Data will saved in list indicatorsCachedUId of HealthDataController
    /// - Runs completion with type and indicators. Even if ERROR it tryes to get from indicatorsCachedUId
    /// - Does not send to delegate if data is the same
    func updateIndicatorOf(profileId: Int, type: HealthParamsEnum, range: HealthParamsEnum.StaticticRange, completion: ((_ hType: HealthParamsEnum, _ hIndicators: HistoricalIndicators?) -> ())? = nil) {
        HealthParamsManager.shared.getStatictic(userId: profileId, type: type, range: range) { (paramsOp, errorOp) in
            if let pr = paramsOp {
                if self.indicatorsCachedUId[profileId] == nil {
                    self.indicatorsCachedUId[profileId] = self.generateStartedHistoricalIndicatorsByType()
                }
                self.indicatorsCachedUId[profileId]?[type]?.updateValue(pr, forKey: range)
                
                // print("HD getStatictic U-\(profileId): tp: \(type.nameVorRequest) r: \(range.rawValue) c: \(String(describing: paramsOp?.count))")
                completion?(type, self.indicatorsCachedUId[profileId]?[type])
            }
            
            if let er = errorOp {
                // print("HD getStatictic U-\(profileId) tp: \(type.nameVorRequest) r: \(range.rawValue) ERROR: \(er.message)")
                completion?(type, self.indicatorsCachedUId[profileId]?[type])
            }
        }
    }
    
    /// Updates sleep recomendations from server
    /// - data will saved in list sleepRecommendations of HealthDataController
    func updateSleepRecomendations() {
        SleepManager.shared.getRecommendations { result, error in
            if let res = result {
                // print("HD getRecomendations: \(res.count)")
                self.sleepRecommendations = res
                self.sleepDelegate?.sleepRecommendationsUpdated?()
            }
            
            if let er = error {
                // print("HD getRecomendations ERROR: \(er.statusCode) \(er.message)")
                self.sleepDelegate?.sleepRecommendationsUpdated?(error: er.message)
            }
        }
    }
    
    /// Method gets first sleep
    func getFistSleep(completion: SleepCompletion? = nil) {
        findSleep(index: 1, completion: completion)
    }
    
    /// Method looking sleep next of currentSleepDate of HealthDataController
    /// - Can't go to the future. Starts completion with nil if tries
    /// - Tries to switch currentSleepDate to next. Starts completion with nil if fail
    /// - Rewrites currentSleepDate to next
    /// - Returns: currentSleepDate of HealthDataController
//    func getNextSleep(completion: SleepCompletion? = nil) -> Date {
//        guard !currentSleepDate.isSameDay(with: Date()),
//              let next = currentSleepDate.next() else {
//            completion?(nil)
//            return currentSleepDate
//        }
//        currentSleepDate = next
//        findSleep(completion: completion)
//        return currentSleepDate
//    }
    
    /// Method looking sleep befor of currentSleepDate of HealthDataController
    /// - Tries to switch currentSleepDate to previous. Starts completion with nil if fail
    /// - Rewrites currentSleepDate to previous
    /// - Returns: currentSleepDate of HealthDataController
//    func getPreviousDaySleep(completion: SleepCompletion? = nil) -> Date {
//        guard let previous = currentSleepDate.previous() else {
//            completion?(nil)
//            return currentSleepDate
//        }
//        currentSleepDate = previous
//        findSleep(completion: completion)
//        return currentSleepDate
//    }
    
    /// Method looking sleep of specific Index
    /// - Index must start from 1
    /// - Checks in sleepHistory of HealthDataController
    /// - If the previous fails, checks sleepHistory of all avalible devices
    /// - If the previous fails, tries to get from server
    func findSleep(index: Int, completion: SleepCompletion? = nil) {
        if index <= 0 {
            completion?(nil)
            fatalError("HealthDataController ERROR: Sleep index starts from 1 ...")
        }
        
        if let sm = sleepHistory[index] {
            completion?(sm)
            return
        }
        
        DeviceType.allCases.forEach { device in

        }
        
        getFromServer(index: index) { sm_ in
            completion?(sm_)
            return
        }
    }
    
    /// Gets quantity of last Sleeps from server
    /// - Сounts from 1 (last) to the specified quantity inclusive
    /// - Method uses getFromServer method to get data
    /// - Data will saved in list sleepHistory of HealthDataController
    /// - Parameters:
    ///   - quantity: the number of previous days from today. Should be greater than 0
    func updateSleep(quantity: Int = 10) {
        if quantity <= 0 {
            print("HD updateSleepLastDays ERROR: countOfPrewDays <= 0")
            return
        }
        
        (0...quantity).forEach { index in
            getFromServer(index: index)
        }
    }
    
    /// Gets Sleep by specific index
    /// - Saves data in dict sleepHistory of HealthDataController
    /// - if index are not provided gets first (1)
    /// - Calls Sleep Delegate
    /// - Runs completion in any case
    /// - Parameters:
    ///   - sleepModel: Init new model and set date SleepModel(date: YOUR_DATE_HERE)
    func getFromServer(index: Int = 1, completion: SleepCompletion? = nil) {
        SleepManager.shared.getBy(index: index) { _sleepM, _error in
            if let sm = _sleepM?.first {
                // print("HD getFromServer Sleep \(index) \(sm.details.count) \(sm.id)")
                self.sleepHistory.updateValue(sm, forKey: index)
                self.sleepDelegate?.sleepDataUpdated?()
            } else {
                // print("HD getFromServer Sleep: List Empty")
            }
            
            if let error = _error {
                // print("HD getFromServer Sleep ERROR: \(error)")
            }
            
            completion?(_sleepM?.first)
        }
    }
}



// MARK: - Safe Health data to server or cache
extension HealthDataController {
    /// Saves to server list of SleepModels. Uses for each sleep in list saveToServer one sleepModel of HealthDataController
    func saveToServer(sleepList: [SleepModel]) {
        sleepList.forEach { sleepModel in
            saveToServer(sleepModel: sleepModel)
        }
    }
    
    func saveToServer(sleepModel: SleepModel, completion: SleepCompletion? = nil) {
        SleepManager.shared.save(model: sleepModel) { _result, error in
            if let sm = _result {
                // print("HD saveToServer Sleep \(sm)")
            }
            if let er = error {
                // print("HD saveToServer Sleep ERROR \(er)")
            }
            completion?(_result)
        }
    }
    
    func saveHealthParamsServer(healthParams: ListHParameterModel) {
        DispatchQueue.background {
            HealthParamsManager.shared.writeListHParams(model: healthParams) { (success, errorOp) in
                if success {
                    // print("HD saveHealthParamsServer success \(healthParams.temperature.count) \(healthParams.temperature.first?.date?.toDate()?.getDateForRequest() ?? "-"), \(healthParams.pulse.count) \(healthParams.pulse.first?.date?.toDate()?.getDateForRequest() ?? "-"), \(healthParams.bloodOxygen.count) \(healthParams.bloodOxygen.first?.date?.toDate()?.getDateForRequest() ?? "-"), \(healthParams.bloodPressure.count) \(healthParams.bloodPressure.first?.date?.toDate()?.getDateForRequest() ?? "-")")
                }

                if let error = errorOp {
                    print("HD saveHealthParamsServer ERROR \(error)")
                }
            }
        } completion: { }
    }
}




// MARK: - Health Data Enum
enum HealthDataType: EnumKit, CaseIterable {
    case sleep
    case indicators
    
    var hdController: HealthDataController { .shared }
    
    func updateData() {
        switch self {
        case .sleep:
            hdController.updateSleepRecomendations()
            hdController.updateSleep()
        case .indicators:
            HealthParamsEnum.allCases.forEach { iType in
                HealthParamsEnum.StaticticRange.allCases.forEach { sRange in
                    hdController.updateIndicator(type: iType, range: sRange)
                }
            }
        }
    }
}
