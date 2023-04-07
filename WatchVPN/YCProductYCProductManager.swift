//
//  YCProductManager.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 08.07.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import CoreBluetooth
import YCProductSDK

// MARK: - YCPHealthIndicator
enum YCPCollectData: CaseIterable {
    case ecg //, ppg
    
    var YCQDataType: YCCollectDataType {
        switch self {
        case .ecg:
            return .ecg
//        case .ppg:
//            return .ppg
        }
    }
}

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
    
    var name: String {
        switch self {
        case .step:
            return "step"
        case .sleep:
            return "sleep"
        case .heartRate:
            return "heartRate"
        case .bloodPressure:
            return "bloodPressure"
        case .bloodOxygen:
            return "bloodOxygen"
        case .bodyTemperature:
            return "bodyTemperature"
        }
    }
}



// MARK: - YCProduct Manager

class YCProductManager {
    
    static let shared = YCProductManager()
    let ycpInstance = YCProduct.shared
    let ecgManager = YCECGManager.shared
    let scanningDeviceDelayTime: TimeInterval = 10
    
    var currentDevice: CBPeripheral? { YCProduct.shared.currentPeripheral }
    var isCurrentSupportRealTimeECG: Bool { currentDevice?.supportItems.isSupportRealTimeECG ?? false }
    
    private init() {
        initSetUp()
    }
    
    func initSetUp() {
        YCProduct.setLogLevel(.normal)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(deviceStateChanged(_:)), name: YCProduct.deviceStateNotification, object: nil
        )
    }
    
    @objc private func deviceStateChanged(_ ntf: Notification) {
        guard let info = ntf.userInfo as? [String: Any],
              let st = info[YCProduct.connecteStateKey] as? YCProductState else {
            print("YCP StateChanged NIL")
            return
        }
        print("YCP StateChanged: \(st.rawValue) \(st.name)")
        
        switch st {
        case .connected:
            afterConnectionSysnc()
        case .poweredOn:
            scanningDevices()
        default:
            break
        }
    }
    
    func scanningDevices() {
        if currentDevice != nil {
            setDeviceTime()
            updateAllData()
            return
        }
        
        YCProduct.scanningDevice(delayTime: scanningDeviceDelayTime) { devices, error in
            //print("YCP scanning ERROR:", error?.localizedDescription as Any)
            for device in devices {
                // print("YCP scanning:", device.name ?? "", device.identifier.uuidString)
                if device.name == UserSettings.currentDeviceName, self.currentDevice != device {
                    self.connect(device: device)
                }
            }
        }
    }
    
    func connect(device: CBPeripheral) {
        YCProduct.connectDevice(device) { state, error in
            print("YCP connect:", state.name, error?.localizedDescription as Any)
        }
    }
    
    func afterConnectionSysnc() {
        setDeviceTime()
        setDeviceMonitoring()
        updateAllData()
    }
    
    func updateAllData() {
        queryAllHealthData()
        //queryCollectionData()
    }
    
    func setDeviceTime() {
        let curr = Date()
        
        YCProduct.setDeviceTime(
            year: UInt16(curr.current(.year)),
            month: UInt8(curr.current(.month)),
            day: UInt8(curr.current(.day)),
            hour: UInt8(curr.current(.hour)),
            minute: UInt8(curr.current(.minute)),
            second: UInt8(curr.current(.second)),
            weekDay: YCWeekDay(rawValue: UInt8(curr.current(.weekday))) ?? .monday
        ) { state, response in
            print("YCP setDeviceTime:", state.name , response as Any)
        }
    }
    
    func setDeviceMonitoring() {
        YCProduct.setDeviceHeartRateMonitoringMode(isEnable: true, interval: 15) { state, response in
            print("YCP setDeviceMonitoring HeartRate:", state.name , response as Any)
        }
        
        YCProduct.setDeviceTemperatureMonitoringMode(isEnable: true, interval: 15) { state, response in
            print("YCP setDeviceMonitoring Temperature:", state.name , response as Any)
        }
        
        YCProduct.setDeviceBloodPressureMonitoringMode(isEnable: true, interval: 15) { state, response in
            print("YCP setDeviceMonitoring BloodPressure:", state.name , response as Any)
        }
        
        YCProduct.setDeviceBloodOxygenMonitoringMode(isEnable: true, interval: 15) { state, response in
            print("YCP setDeviceMonitoring BloodOxygen:", state.name , response as Any)
        }
    }
    
    func queryAllHealthData() {
        for dataType in YCPHealthIndicator.allCases {
            YCProduct.queryHealthData(datatType: dataType.YCQDataType) { state, response in
                print("YCP queryHealthData:", dataType, state.name, response as Any)
                self.handleHealthData(dataType: dataType, state: state, response: response)
            }
        }
    }
    
    func handleHealthData(dataType: YCPHealthIndicator, state: YCProductState, response: Any?) {
        sendLogsToServer(string: "--- YCP \(dataType.name) \((response as? [Any])?.count as Any)")
        guard let token = UserSettings.currentUserToken else {
            sendLogsToServer(string: "--- ERROR token nil")
            return
        }
        
        if state == .succeed, let datas = response as? [Any] {
            switch dataType {
            case .step:
                return
            case .sleep:
                // FIX SAve
                break
                // HealthDataController.shared.saveToServer(YCSleepList: datas as? [YCHealthDataSleep])
            default:
                sendLogsToServer(string: "--- YCP \(dataType.name) \(datas.count)")
                // FIX SAve
                HealthParamsManager.shared.writeListHParams(
                    token: token,
                    model: ListHParameterModel(YCPDataType: dataType, data: datas)
                ) { (success, errorOp) in
                    self.sendLogsToServer(string: "--- YCP save data to server \(success as Any) \(errorOp as Any)...")
                }
                // HealthDataController.shared.saveHealthParamsServer(healthParams: ListHParameterModel(YCPDataType: dataType, data: datas))
            }
        }
    }
    
    func queryCollectionData() {
        for cType in YCPCollectData.allCases {
            print("YCP c \(cType)")
            YCProduct.queryCollectDataBasicinfo(dataType: cType.YCQDataType) { state, response in
                print("YCP c \(cType):", state.name, response as Any)
                guard state == .succeed, let datas = response as? [YCCollectDataBasicInfo] else {
                    print("YCP c \(cType) Warning ...")
                    return
                }
                print("YCP c \(cType):", datas)
                for dt in datas {
                    print("YCP c \(cType):", dt)
                    print("YCP c \(cType) dataType     :", dt.dataType)
                    print("YCP c \(cType) index        :", dt.index)
                    print("YCP c \(cType) timeStamp    :", dt.timeStamp)
                    print("YCP c \(cType) sampleRate   :", dt.sampleRate)
                    print("YCP c \(cType) samplesCount :", dt.samplesCount)
                    print("YCP c \(cType) totalBytes   :", dt.totalBytes)
                    print("YCP c \(cType) packages     :", dt.packages)
                    print("YCP c \(cType) toString     :", dt.toString)
                    self.queryDetailedCollectionInfo(collectionType: cType, index: dt.index)
                }
            }
        }
    }
    
    func queryDetailedCollectionInfo(collectionType: YCPCollectData, index: UInt16) {
        YCProduct.queryCollectDataInfo(dataType: collectionType.YCQDataType, index: index, uploadEnable: true) { state, response in
            
            if state == .succeed, let info = response as? YCCollectDataInfo {
                if info.isFinished {
                    print("YCP c \(collectionType):", state.name, response as Any)
                    print("YCP c \(collectionType) Finished:", info.basicInfo.toString)
                    print("YCP c \(collectionType) Finished:", info.data.count, info.data.first as Any)
                } else {
                    // print("YCP ECG in progress:", info.progress)
                }
            } else if state == .failed {
                print("YCP c \(collectionType):", state.name, response as Any)
            }
        }
    }
    
    func sendLogsToServer(string: String) {
        ImagesManager.shared.getBy(link: string) { (success, error) in }
    }
}



// MARK: - Extensions

extension YCProductState {
    var name: String {
        switch self {
        case .unknow:
            return "unknow"
        case .resetting:
            return "resetting"
        case .unsupported:
            return "unsupported"
        case .unauthorized:
            return "unauthorized"
        case .poweredOff:
            return "poweredOff"
        case .poweredOn:
            return "poweredOn"
        case .disconnected:
            return "disconnected"
        case .connected:
            return "connected"
        case .connectedFailed:
            return "connectedFailed"
        case .unavailable:
            return "unavailable"
        case .timeout:
            return "timeout"
        case .dataError:
            return "dataError"
        case .crcError:
            return "crcError"
        case .dataTypeError:
            return "dataTypeError"
        case .succeed:
            return "succeed"
        case .failed:
            return "failed"
        case .noRecord:
            return "noRecord"
        case .parameterError:
            return "parameterError"
        case .alarmNotExist:
            return "alarmNotExist"
        case .alarmAlreadyExist:
            return "alarmAlreadyExist"
        case .alarmCountLimit:
            return "alarmCountLimit"
        case .alarmTypeNotSupport:
            return "alarmTypeNotSupport"
        case .invalidMacaddress:
            return "invalidMacaddress"
        @unknown default:
            return "@unknown default"
        }
    }
}

extension HealthParameterModel {
    init(heartRate: YCHealthDataHeartRate) {
        id = -1
        value = Float(heartRate.heartRate)
        date = heartRate.startTimeStamp.getDate().getTimeDateForRequest()
        additionalValue = nil
        dateDType = heartRate.startTimeStamp.getDate()
    }
    
    init(bloodPressure: YCHealthDataBloodPressure) {
        id = -1
        value = Float(bloodPressure.systolicBloodPressure)
        date = bloodPressure.startTimeStamp.getDate().getTimeDateForRequest()
        additionalValue = Float(bloodPressure.diastolicBloodPressure)
        dateDType = bloodPressure.startTimeStamp.getDate()
    }
    
    init(bloodOxygen: YCHealthDataBloodOxygen) {
        id = -1
        value = Float(bloodOxygen.bloodOxygen)
        date = bloodOxygen.startTimeStamp.getDate().getTimeDateForRequest()
        additionalValue = nil
        dateDType = bloodOxygen.startTimeStamp.getDate()
    }
    
    init(bodyTemperature: YCHealthDataBodyTemperature) {
        id = -1
        value = Float(bodyTemperature.temperature)
        date = bodyTemperature.startTimeStamp.getDate().getTimeDateForRequest()
        additionalValue = nil
        dateDType = bodyTemperature.startTimeStamp.getDate()
    }
}

extension YCHealthDataSleepType {
//    var misuType: SleepPhaseType {
//        switch self {
//        case .unknow:
//            return .REM
//        case .deepSleep:
//            return .deep
//        case .lightSleep:
//            return .light
//        @unknown default:
//            return .awake
//        }
//    }
}

//extension SleepPhaseModel {
//    convenience init(from phase: YCHealthDataSleepDetail) {
//        self.init()
//        dateTime = phase.startTimeStamp.getDate().getTimeDateForRequest()
//        duration = phase.duration
//        pType = phase.sleepType.misuType
//    }
//}
//
//extension SleepModel {
//    convenience init(from sleep: YCHealthDataSleep) {
//        self.init()
//        details = sleep.sleepDetailDatas.map({ dt in
//            return SleepPhaseModel(from: dt)
//        })
//
//        REMDuration = sleep.remSleepMinutes == 0 ? REMCalcDuration : sleep.remSleepMinutes
//        lightDuration = sleep.lightSleepMinutes == 0 ? lightCalcDuration : sleep.lightSleepMinutes
//        deepDuration = sleep.deepSleepMinutes == 0 ? deepCalcDuration : sleep.deepSleepMinutes
//
//        dateTime = sleep.startTimeStamp.getDate().getTimeDateForRequest()
//    }
//}
//
//extension HealthDataController {
//    func saveToServer(YCSleepList: [YCHealthDataSleep]?) {
//        guard let sls = YCSleepList else {
//            print("YCP sleep NIL ERROR ...")
//            return
//        }
//        let misuSleepList = sls.map({ SleepModel(from: $0) })
//        saveToServer(sleepList: misuSleepList)
//    }
//}

extension ListHParameterModel {
    init(YCPDataType: YCPHealthIndicator, data: [Any]) {
        switch YCPDataType {
        case .heartRate:
            pulse = convertParams(heartRate: data)
        case .bloodPressure:
            bloodPressure = convertParams(bloodPressure: data)
        case .bloodOxygen:
            bloodOxygen = convertParams(bloodOxygen: data)
        case .bodyTemperature:
            temperature = convertParams(bodyTemperature: data)
        default:
            return
        }
    }

    func convertParams(heartRate: [Any]) -> [HealthParameterModel] {
        guard let hr = heartRate as? [YCHealthDataHeartRate] else {
            print("YCP convertParams heartRate: TYPE ERROR")
            return []
        }
        return hr.map { sample in
            return .init(
                value: Float(sample.heartRate),
                additionalValue: nil,
                date: sample.startTimeStamp.getDate().getTimeDateForRequest()
            )
        }
    }

    func convertParams(bloodPressure: [Any]) -> [HealthParameterModel] {
        guard let bp = bloodPressure as? [YCHealthDataBloodPressure] else {
            print("YCP convertParams bloodPressure: TYPE ERROR")
            return []
        }
        return bp.map { sample in
            return .init(
                value: Float(sample.systolicBloodPressure),
                additionalValue: Float(sample.diastolicBloodPressure),
                date: sample.startTimeStamp.getDate().getTimeDateForRequest()
            )
        }
    }

    func convertParams(bloodOxygen: [Any]) -> [HealthParameterModel] {
        guard let samples = bloodOxygen as? [YCHealthDataBloodOxygen] else {
            print("YCP convertParams bloodOxygen: TYPE ERROR")
            return []
        }
        return samples.map { sample in
            return .init(
                value: Float(sample.bloodOxygen),
                additionalValue: nil,
                date: sample.startTimeStamp.getDate().getTimeDateForRequest()
            )
        }
    }

    func convertParams(bodyTemperature: [Any]) -> [HealthParameterModel] {
        guard let samples = bodyTemperature as? [YCHealthDataBodyTemperature] else {
            print("YCP convertParams bodyTemperature: TYPE ERROR")
            return []
        }
        return samples.map { sample in
            return .init(
                value: Float(sample.temperature),
                additionalValue: nil,
                date: sample.startTimeStamp.getDate().getTimeDateForRequest()
            )
        }
    }
}
