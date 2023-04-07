//
//  YCProductManager.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 08.07.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//  5168e9b3c4070bb03a685e1e8514fc39fac94f74

import Foundation
import CoreBluetooth
import YCProductSDK


// MARK: - Delegates

protocol YCPConnectingDelegate: DeviceConnectionDelegate {}

protocol YCPDataProcessingDelegate: DeviceDataProcessingDelegate { }

@objc protocol YCProductDelegate {
    @objc optional func stateChanged(_ state: YCProductState)
    @objc optional func didDiscoverDevice(_ device: CBPeripheral)
}

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


// MARK: - YCProduct Manager

class YCProductManager: WatchManager {
    
    override var userDefaultKey: String {
        "i8&#*YD#aFdS#soGgsd%)s#*D&*#dg"
    }
    
    static let shared = YCProductManager()
    
    let ycpInstance = YCProduct.shared
    let ecgManager = YCECGManager.shared
    var connectionDelegate: YCPConnectingDelegate?
    var dataProcessingDelegate: YCPDataProcessingDelegate?
    var ycpDelegate: YCProductDelegate?
    var currentDevice: CBPeripheral? { YCProduct.shared.currentPeripheral }
    var currentBatteryPower: Int = 0
    
    private var state: YCProductState = .unknow
    private var isCurrentSupportRealTimeECG: Bool { currentDevice?.supportItems.isSupportRealTimeECG ?? false }
    private var currentHealthDataProcessing: [YCPHealthIndicator] = []
    private var currentCollectDataProcessing: [YCPCollectData] = []
    private var collectionDataCount: Int = 0
    
    private override init() {
        super.init()
        initSetUp()
    }
    
    override func scanningDevices() {
        connectionDelegate?.willStartScanning()
        YCProduct.scanningDevice(delayTime: scanningDeviceDelayTime) { [weak self] devices, error in
            self?.connectionDelegate?.didUpdateScanning(devices: devices)
            
//            print("YCP scanning ERROR:", error?.localizedDescription as Any)
//            for device in devices {
//                if device.name == "P11 MISU1s EB79", device != self?.currentDevice {
//                    self?.connect(device: device)
//                }
//                 print("YCP scanning:", device.name ?? "", device.identifier.uuidString)
//                 self?.ycpDelegate?.didDiscoverDevice?(device)
//            }
        }
    }
    
    override func connect(device: CBPeripheral) {
        connectionDelegate?.willStartConnecting()
        YCProduct.connectDevice(device) { state, error in
            // print("YCP connect:", state.name, error?.localizedDescription as Any)
            
            if state == .connected {
                KeyStore.saveValue(true, for: .didConnectWatchOnce)
                self.connectionDelegate?.didEndConnecting(
                    succes: state == .connected,
                    descrition: state.name
                )
                NotificationManager.shared.post(.didConnectWatch, object: MISUWatch(cbPeripheral: device))
            }
        }
    }
    
    override func disconnect(device: CBPeripheral?) {
        connectionDelegate?.willDisconnect?()
        YCProduct.disconnectDevice(device)
    }
    
    override func updateAllData() {
        print("updateAllData")
        dataProcessingDelegate?.willStartDataReading()
        queryAllHealthData()
        
//        queryCollectionData()
    }
}

// Device state management
extension YCProductManager {
    
    @objc private func deviceStateChanged(_ ntf: Notification) {
        guard let info = ntf.userInfo as? [String: Any],
              let st = info[YCProduct.connecteStateKey] as? YCProductState else {
            // print("YCP StateChanged NIL")
            return
        }
        state = st
        ycpDelegate?.stateChanged?(st)
         print("YCP StateChanged: \(st.rawValue) \(st.name)")
        
        switch st {
        case .disconnected:
            connectionDelegate?.didDisconnect?()
        case .connected:
            // disconnect(device: currentDevice)
            setDeviceTime()
            afterConnectionSync()
        case .poweredOn:
            scanningDevices()
        default:
            break
        }
    }
    
    func setDeviceLanguage() {
        // print("YCP languageCode \(Locale.current.languageCode)")
        
        var lang: YCProductSDK.YCDeviceLanguageType = .english
        switch Locale.current.languageCode {
        case "uk", "ru":
            lang = .ukrainian
        case "pl":
            lang = .poland
        case "fr":
            lang = .french
        default:
            break
        }
        
        YCProduct.setDeviceLanguage(language: lang) { state, response in
            // print("YCP setDeviceLanguage: \(state.name)")
            // print("YCP setDeviceLanguage: \(response as Any)")
        }
    }
    
    func updateDeviceModel() {
        guard let name = currentDevice?.name, let did = currentDevice?.identifier.uuidString else {
            // print("YCP updateDeviceModel: NIL ERROR")
            return
        }
        // print("YCP updateDeviceModel:", name, "|", did)
        deviceModel = DeviceModel(name: name, dmac: did)
        saveDeviceConnection()
    }
    
    func getDeviceBasicInfo() {
        YCProduct.queryDeviceBasicInfo { state, response in
            // print("YCP BatteryPower:", state.name, response as Any)
            if state == .succeed, let info = response as? YCDeviceBasicInfo {
                self.currentBatteryPower = Int(info.batteryPower)
                self.dataProcessingDelegate?.didUpdate?(batteryPower: Int(info.batteryPower))
                // print("YCP BatteryPower:", info.batteryPower)
            }
        }
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
            // print("YCP setDeviceTime:", state.name , response as Any)
        }
    }
    
    func setDeviceMonitoring() {
        YCProduct.setDeviceHeartRateMonitoringMode(isEnable: true, interval: 15) { state, response in
            // print("YCP setDeviceMonitoring HeartRate:", state.name , response as Any)
        }
        
        YCProduct.setDeviceTemperatureMonitoringMode(isEnable: true, interval: 15) { state, response in
            // print("YCP setDeviceMonitoring Temperature:", state.name , response as Any)
        }
        
        YCProduct.setDeviceBloodPressureMonitoringMode(isEnable: true, interval: 15) { state, response in
            // print("YCP setDeviceMonitoring BloodPressure:", state.name , response as Any)
        }
        
        YCProduct.setDeviceBloodOxygenMonitoringMode(isEnable: true, interval: 15) { state, response in
            // print("YCP setDeviceMonitoring BloodOxygen:", state.name , response as Any)
        }
    }
    
}

// Indicators Handling
private extension YCProductManager {
    
    func queryAllHealthData() {
        for dataType in YCPHealthIndicator.allCases {
            addProcess(dataType)
            YCProduct.queryHealthData(datatType: dataType.YCQDataType) { state, response in
                // print("YCP queryHealthData:", dataType, state.name, response as Any)
                self.removeProcess(dataType)
                self.handleHealthData(dataType: dataType, state: state, response: response)
            }
        }
    }
    
    func handleHealthData(dataType: YCPHealthIndicator, state: YCProductState, response: Any?) {
        // print("YCP handleHealthData:", dataType, state.name, response as Any)
        
        if let heartData = response as? [YCHealthDataHeartRate] {
            if !heartData.isEmpty {
                let indicators = heartData.map { _HealthIndicator($0) }
                HealthDataCenter.shared.heartrateIndicators = indicators
                // RealmIndicator.insertBulk(indicators, type: .heartrate)
            }
        }
        
        if let pressure = response as? [YCHealthDataBloodPressure] {
            if !pressure.isEmpty {
                let indicators = pressure.map { _HealthIndicator($0) }
                HealthDataCenter.shared.pressureIndicators = indicators
                // RealmIndicator.insertBulk(indicators, type: .pressure)
            }
        }
        
        if let oxygen = response as? [YCHealthDataBloodOxygen] {
            if !oxygen.isEmpty {
                let indicators = oxygen.map { _HealthIndicator($0) }
                HealthDataCenter.shared.oxygenIndicators = indicators
                // RealmIndicator.insertBulk(indicators, type: .oxygen)
            }
        }
        
        if let temperature = response as? [YCHealthDataBodyTemperature] {
            if !temperature.isEmpty {
                let indicators = temperature.map { _HealthIndicator($0) }
                HealthDataCenter.shared.temperatureIndicators = indicators
                // RealmIndicator.insertBulk(indicators, type: .temperature)
            }
        }
        
        if let sleep = response as? [YCHealthDataSleep] {
            for record in sleep {
                let sleepRecord = RealmSleepIndicator(record)
                sleepRecord.save()
            }
        }
        
        
        /*
        if state == .succeed, let datas = response as? [Any] {
            switch dataType {
            case .step:
                return
            case .sleep:
                HealthDataController.shared.saveToServer(
                    YCSleepList: datas as? [YCHealthDataSleep]
                )
            default:
                HealthDataController.shared.saveHealthParamsServer(
                    healthParams: ListHParameterModel(YCPDataType: dataType, data: datas)
                )
            }
        }
         */
        
    }
    
    func queryCollectionData() {
//        print("queryCollectionData")
        for cType in YCPCollectData.allCases {
            addProcess(cType)
//            cType.YCQDataType
            YCProduct.queryCollectDataBasicinfo(dataType: cType.YCQDataType) { state, response in
//                Tests
//                print("YCP queryCollectDataBasicinfo \(cType):", state.name, response as Any, response as? [YCCollectDataBasicInfo] as Any)
                guard state == .succeed, let datas = response as? [YCCollectDataBasicInfo], !datas.isEmpty else {
//                    print("YCP c \(cType) Warning ...")
                    self.removeProcess(cType)
                    return
                }
                
                self.collectionDataCount += datas.count
                for dt in datas {
//                    Tests
//                    print("YCP c \(cType):", dt)
//                    print("YCP c \(cType) dataType     :", dt.dataType)
//                    print("YCP c \(cType) index        :", dt.index)
//                    print("YCP c \(cType) timeStamp    :", dt.timeStamp)
//                    print("YCP c \(cType) sampleRate   :", dt.sampleRate)
//                    print("YCP c \(cType) samplesCount :", dt.samplesCount)
//                    print("YCP c \(cType) totalBytes   :", dt.totalBytes)
//                    print("YCP c \(cType) packages     :", dt.packages)
//                    print("YCP c \(cType) toString     :", dt.toString)
                    self.queryDetailedCollectionInfo(collectionType: cType, index: dt.index)
                }
            }
        }
    }
    
    func queryDetailedCollectionInfo(collectionType: YCPCollectData, index: UInt16) {
//        print("YCP queryDetailedCollectionInfo")
        YCProduct.queryCollectDataInfo(dataType: collectionType.YCQDataType, index: index, uploadEnable: true) { state, response in
            
            if state == .succeed, let info = response as? YCCollectDataInfo {
                if info.isFinished {
//                     print("YCP c \(collectionType):", state.name, info as Any)
                    // print("YCP c \(collectionType) Finished:", info.basicInfo.toString)
                    // print("YCP c \(collectionType) Finished:", info.data.count, info.data.first as Any)
                } else {
                    // print("YCP ECG in progress:", info.progress)
                }
            } else if state == .failed {
                // print("YCP c Failed \(collectionType):", state.name, response as Any)
            }
            
            if let info = response as? YCCollectDataInfo, info.isFinished {
                // print("YCP DTest ", self.collectionDataCount)
                self.collectionDataCount -= 1
                if self.collectionDataCount < 0 {
                    self.collectionDataCount = 0
                }
                
                if self.collectionDataCount == 0 {
                    self.removeProcess(collectionType)
                }
            }
        }
    }
    
}

private extension YCProductManager {
    
    func initSetUp() {
//         Test
//         connectionDelegate = self
//         dataProcessingDelegate = self
//         ycpDelegate = self
        
        YCProduct.setLogLevel(.off)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(deviceStateChanged(_:)), name: YCProduct.deviceStateNotification, object: nil
        )
    }
    
    func afterConnectionSync() {
        
        guard WatchConnectionManager.shared.currentWatch() is MISUWatch else { return }
        
//        print("afterConnectionSync")
        dataProcessingDelegate?.willStartDeviceInfoSync?()
        updateDeviceModel()
        getDeviceBasicInfo()
        setDeviceMonitoring()
        setDeviceLanguage()
        dataProcessingDelegate?.didEndDeviceInfoSync?()
//        updateAllData()
        DispatchQueue.global().async { [weak self] in
            self?.updateAllData()
        }
    }
    
    func addProcess(_ pType: YCPHealthIndicator) {
        currentHealthDataProcessing.append(pType)
    }
    
    func addProcess(_ pType: YCPCollectData) {
        currentCollectDataProcessing.append(pType)
    }
    
    func removeProcess(_ pType: YCPHealthIndicator) {
        currentHealthDataProcessing.removeAll(where: {$0 == pType})
        updateProcessing()
    }
    
    func removeProcess(_ pType: YCPCollectData) {
        currentCollectDataProcessing.removeAll(where: {$0 == pType})
        updateProcessing()
    }
    
    func updateProcessing() {
        dataProcessingDelegate?.updatedDataReadingProcess(percent: calculateProcessingPercent())
        if currentCollectDataProcessing.isEmpty && currentHealthDataProcessing.isEmpty {
            dataProcessingDelegate?.didEndDataReading()
        }
    }
    
    func calculateProcessingPercent() -> Float {
        let all = YCPHealthIndicator.allCases.count + YCPCollectData.allCases.count
        let curr = currentHealthDataProcessing.count + currentCollectDataProcessing.count
        
        let percent: Float = 1 - Float(curr)/Float(all)

        return (percent < 0 ? 0 : (percent > 1 ? 1 : percent))
    }
    
}
