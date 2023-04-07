//
//  TrusangManager.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 01.11.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation
import TrusangBluetooth
import CoreBluetooth


// MARK: - Protocols
protocol TrusangConnectionDelegate: DeviceConnectionDelegate {
    func didUpdateScanning(devices: [ZHJBTDevice])
}

protocol TrusangDataProcessingDelegate: DeviceDataProcessingDelegate { }



// MARK: - TrusangManager
class TrusangManager: WatchManager {
    override var userDefaultKey: String { "i8&#*YDMISUsad31WATCH7dG#*D&*#dg" }
    
    static let shared = TrusangManager()
    private override init() {
        super.init()
        // Tests
        // connectionDelegate = self
        // dataProcessingDelegate = self
        
        if KeychainUtility.getCurrentUserToken() == nil {
            removeAutoReconnect()
            isConnected = false
            disconnectDevice()
        }
        bluetoothPrepare()
    }
    
    let btProvider = ZHJBLEManagerProvider.shared
    let enablePairProcessor = ZHJEnablePairProcessor()
    let batteryProcessor = ZHJBatteryProcessor()
    let syncTimeProcessor = ZHJSyncTimeProcessor()
    let HR_BP_BOProcessor = ZHJHR_BP_BOProcessor()
    let temperatureProcessor = ZHJTemperatureProcessor()
    let stepAndSleepProcessor = ZHJStepAndSleepProcessor()
    let deviceConfigProcessor = ZHJDeviceConfigProcessor()
    var deviceConfig = ZHJDeviceConfig()
    //let messageNoticeProcessor = ZHJMessageNoticeProcessor()
    
    let wFSequencer = TrusangFuncSequencer.shared
    
    var dataProcessingDelegate: TrusangDataProcessingDelegate? = nil
    var dataProcessingSequence: Int = 0
    var dataProcessingAmount: Int = 0
    var dataProcessingPercent: Float { 1 - Float(dataProcessingSequence)/Float(dataProcessingAmount) }
    
    var connectionDelegate: TrusangConnectionDelegate? = nil
    var listOfAvaalibleDevices: [ZHJBTDevice] = []
    var connectedDeviceCB: CBPeripheral? {
        connectedDeviceZHJ?.peripheral
    }
    var connectedDeviceZHJ: ZHJBTDevice? {
        btProvider.currentDevice
    }
    
    var devicePow: Int? {
        didSet {
            dataProcessingDelegate?.didUpdate?(batteryPower: devicePow ?? 0)
        }
    }
    
    var indicatorsDateRange: [Date] {
        var dt: [Date] = [Date()]
        (0..<7).forEach { _ in
            guard let pdt = dt.last?.previous() else { return }
            dt.append(pdt)
        }
        return dt
    }
    
    override func scanningDevices() {
        print("ZHJ will scan")
        connectionDelegate?.willStartScanning()
        btProvider.scan(seconds: scanningDeviceDelayTime) { devices in
            print("ZHJ scan \(devices)")
            self.listOfAvaalibleDevices = devices
            self.connectionDelegate?.didUpdateScanning(devices: devices)
            
            let dvs: [CBPeripheral] = devices.reduce(into: [CBPeripheral]()) { partialResult, dv in
                guard let peri = dv.peripheral else { return }
                partialResult.append(peri)
            }
            self.connectionDelegate?.didUpdateScanning(devices: dvs)
        }
    }
    
    override func disconnect(device: CBPeripheral?) {
        disconnectDeviceFully()
    }
    
    override func connect(device: CBPeripheral) {
        if let dev = listOfAvaalibleDevices.first(where: {$0.peripheral == device}) {
            connectDevice(dev)
        } else {
            connectionDelegate?.didEndConnecting(succes: false, descrition: "ZHJ Did NOT found device ...")
        }
    }
}



// MARK: - ZHJ SDK Data Synchronization
extension TrusangManager {
    func afterConnectionSyns(_ completion: (() -> Void)? = nil) {
        print("ZHJ start sync ...")
        if let mac = connectedDeviceZHJ?.mac, let name = connectedDeviceZHJ?.name {
            deviceModel = DeviceModel(name: name, dmac: mac)
            saveDeviceConnection()
        }
        discoverWriteCharacteristic(completion)
    }
    
    override func updateAllData() {
        if isUpdating, !isConnected { return }
        updateSyns()
    }
    
    func discoverWriteCharacteristic(_ completion: (() -> Void)? = nil) {
        btProvider.discoverWriteCharacteristic { [self] characteristic in
            print("ZHJ discoverWriteCharacteristic \(characteristic)")
            updateSyns()
            completion?()
        }
    }
    
    func updateSyns() {
        print("ZHJ start update sync ...")
        wFSequencer.add(.dataProcessingDelegate_willStartDeviceInfoSync)
        wFSequencer.add(.startSyns)
        wFSequencer.add(.syncTime)
        wFSequencer.add(.readBatteryPower)
        
        wFSequencer.add(.dataProcessingDelegate_willStartDataReading)
        dataProcessingSequence = 0
        indicatorsDateRange.forEach { dt in
            dataProcessingSequence += 3
            wFSequencer.add(.readHR_BP_BOHistoryRecord(date: dt))
            wFSequencer.add(.readTemperatureHistoryRecord(date: dt))
            wFSequencer.add(.readStepAndSleepHistoryRecord(date: dt))
        }
        dataProcessingAmount = dataProcessingSequence
        wFSequencer.add(.dataProcessingDelegate_didEndDataReading)
        
        wFSequencer.add(.setAutoDetectTemperature)
        wFSequencer.add(.setAutoDetectHeartRate)
        wFSequencer.add(.readDeviceConfig)
        wFSequencer.add(.messageSwitch)
        wFSequencer.add(.endSyns)
        wFSequencer.add(.dataProcessingDelegate_didEndDeviceInfoSync)
        
    }
    
    func dataProcessingDelegate_willStartDeviceInfoSync(_ completion: (() -> Void)? = nil) {
        dataProcessingDelegate?.willStartDeviceInfoSync?()
        completion?()
    }
    
    func dataProcessingDelegate_didEndDeviceInfoSync(_ completion: (() -> Void)? = nil) {
        dataProcessingDelegate?.didEndDeviceInfoSync?()
        completion?()
    }
    
    func dataProcessingDelegate_willStartDataReading(_ completion: (() -> Void)? = nil) {
        dataProcessingDelegate?.willStartDataReading()
        completion?()
    }
    func dataProcessingDelegate_didEndDataReading(_ completion: (() -> Void)? = nil) {
        dataProcessingDelegate?.didEndDataReading()
        completion?()
    }
    
    func syncTime(_ completion: (() -> Void)? = nil) {
        //print("ZHJ try syncTime \(String(describing: btProvider.currentDevice))")
        syncTimeProcessor.writeTime(ZHJSyncTime.init(Date())) { result in
            if result == .correct {
                print("ZHJ syncTime correct \(String(describing: result))")
            } else {
                print("ZHJ syncTime error \(String(describing: result))")
            }
            completion?()
        }
    }
    
    func readBatteryPower(_ completion: SequencerCompletion? = nil) {
        print("ZHJ try readBatteryPower")
        batteryProcessor.readBatteryPower { [self] pow in
            print("ZHJ readBatteryPower \(pow)")
            devicePow = pow
            completion?()
        }
    }
    
    func setAutoDetectTemperature(_ completion: (() -> Void)? = nil) {
        temperatureProcessor.setAutoDetectTemperature(interval: 15, isOn: true) { result in
            if result == .correct {
                print("ZHJ setAutoDetectTemperature correct \(String(describing: result))")
            } else {
                print("ZHJ setAutoDetectTemperature error \(String(describing: result))")
            }
            completion?()
        }
    }
    
    func setAutoDetectHeartRate(_ completion: (() -> Void)? = nil) {
        HR_BP_BOProcessor.setAutoDetectHeartRate(interval: 15, isOn: true) { result in
            if result == .correct {
                print("ZHJ setAutoDetectHeartRate correct \(String(describing: result))")
            } else {
                print("ZHJ setAutoDetectHeartRate error \(String(describing: result))")
            }
            completion?()
        }
    }
    
    func readStepAndSleepHistoryRecord(date: Date?, _ completion: SequencerCompletion? = nil) {
        let date = date ?? Date()
        print("ZHJ readStepAndSleepHistoryRecord \(date.getDateForRequest())")
        stepAndSleepProcessor.readStepAndSleepHistoryRecord(date: date.getDateForRequest()) { [self] stepsModel, sleepModel in
            print("ZHJ readStepAndSleepHistoryRecord step \(stepsModel) \(sleepModel)")
            let sm = SleepModel(from: sleepModel, dateStr: date.getTimeDateForRequest())
            if let index = self.sleepHistory.firstIndex(of: sm) {
                self.sleepHistory[index] = sm
            } else {
                self.sleepHistory.append(sm)
            }
            HealthDataController.shared.saveToServer(sleepModel: sm)
            dataProcessingSequence -= 1
            dataProcessingDelegate?.updatedDataReadingProcess(percent: dataProcessingPercent)
            completion?()
        } historyDoneHandle: { [self] obj in
            print("ZHJ readStepAndSleepHistoryRecord done \(obj)")
            dataProcessingSequence -= 1
            dataProcessingDelegate?.updatedDataReadingProcess(percent: dataProcessingPercent)
            completion?()
        }
    }
    
    func readHR_BP_BOCurrent(_ completion: (() -> Void)? = nil) {
        HR_BP_BOProcessor.readCurrentHR_BP_BO { (heartRateD, bloodPressureD, bloodOxygenD) in
            print("ZHJ readHR_BP_BOCurrent \n\(heartRateD)\n\(bloodPressureD)\n\(bloodOxygenD)")
            let heartRate = ZHJHeartRate()
            let bloodPressure = ZHJBloodPressure()
            let bloodOxygen = ZHJBloodOxygen()
            heartRateD.dateTime = Date().getTimeDateForRequest()
            bloodOxygenD.dateTime = Date().getTimeDateForRequest()
            bloodPressureD.dateTime = Date().getTimeDateForRequest()
            //print("### ! \(heartRateD.dateTime)")
            bloodPressure.details.append(bloodPressureD)
            heartRate.details.append(heartRateD)
            bloodOxygen.details.append(bloodOxygenD)
            
            HealthDataController.shared.saveHealthParamsServer(
                healthParams: .init(
                    heartRate: heartRate,
                    bloodOxygen: bloodOxygen,
                    bloodPressure: bloodPressure
                )
            )
            completion?()
        }
    }
    
    func readCurrentBP(_ completion: ((_ bp: HealthParameterModel) -> Void)? = nil) {
        HR_BP_BOProcessor.readCurrentHR_BP_BO { _, bloodPressureD, _ in
            print("ZHJ read BP Current \(bloodPressureD)")
            bloodPressureD.dateTime = Date().getTimeDateForRequest()
            HealthDataController.shared.saveHealthParamsServer(
                healthParams: .init(bloodPressure: bloodPressureD))
            completion?(HealthParameterModel(id: -1, value: Float(bloodPressureD.SBP), additionalValue: Float(bloodPressureD.DBP), date: bloodPressureD.dateTime))
        }
    }
    
    func readCurrentTemperature(_ completion: (() -> Void)? = nil) {
        temperatureProcessor.readCurrentTemperature { (temperatureD) in
            print("ZHJ readCurrentTemperature \n\(temperatureD)")
            let temperature = ZHJTemperature()
            temperatureD.dateTime = Date().getTimeDateForRequest()
            temperature.details.append(temperatureD)
            HealthDataController.shared.saveHealthParamsServer(healthParams: .init(temperature: temperature))

            completion?()
        }
    }
    
    func readHR_BP_BOHistoryRecord(date: Date? = nil, _ completion: (() -> Void)? = nil) {
        print("ZHJ readHR_BP_BOHistoryRecord \(date?.getDateForRequest() ?? "nil")")
        HR_BP_BOProcessor.readHR_BP_BOHistoryRecord((date ?? Date()).getDateForRequest()) { [self] (heartRate, bloodPressure, bloodOxygen) in
            //print("ZHJ readHR_BP_BOHistoryRecord \n\(heartRate)\n\(bloodPressure)\n\(bloodOxygen)")
            print("ZHJ readHR_BP_BOHistoryRecord \(date?.getTimeDateForRequest() ?? "nil") \(heartRate.details.count) \(bloodPressure.details.count) \(bloodOxygen.details.count)")
            //print("ZHJ readHRHistoryRecord \n\(heartRate.min)\n\(heartRate.avg)\n\(heartRate.max)")
            //print("### !!! \(bloodOxygen.details.first?.dateTime)")
            DispatchQueue.background {
                HealthDataController.shared.saveHealthParamsServer(
                    healthParams: .init(heartRate: heartRate, bloodOxygen: bloodOxygen, bloodPressure: bloodPressure))
            } completion: {
                
            }
            dataProcessingSequence -= 1
            dataProcessingDelegate?.updatedDataReadingProcess(percent: dataProcessingPercent)
            completion?()
        } historyDoneHandle: { [self] obj in
            print("ZHJ readHR_BP_BOHistoryRecord done \(obj)")
            dataProcessingSequence -= 1
            dataProcessingDelegate?.updatedDataReadingProcess(percent: dataProcessingPercent)
            completion?()
        }
    }
    
    func readTemperatureHistoryRecord(date: Date? = nil, _ completion: SequencerCompletion? = nil) {
        print("ZHJ readTemperatureHistoryRecord \(date?.getDateForRequest() ?? "nil")")
        temperatureProcessor.readTemperatureHistoryRecord((date ?? Date()).getDateForRequest()) { [self] temperature in
            print("ZHJ readTemperatureHistoryRecord \(date?.getTimeDateForRequest() ?? "nil") \n\(temperature)")
            //print("ZHJ readTemperatureHistoryRecord \n\(temperature.details.count) \n\(temperature.details)")
            DispatchQueue.background {
                HealthDataController.shared.saveHealthParamsServer(healthParams: .init(temperature: temperature))
            } completion: {
                
            }
            dataProcessingSequence -= 1
            dataProcessingDelegate?.updatedDataReadingProcess(percent: dataProcessingPercent)
            completion?()
        } historyDoneHandle: { [self] obj in
            print("ZHJ readTemperatureHistoryRecord done \(obj)")
            dataProcessingSequence -= 1
            dataProcessingDelegate?.updatedDataReadingProcess(percent: dataProcessingPercent)
            completion?()
        }
    }
    
    func startSyns(_ completion: (() -> Void)? = nil) {
        print("ZHJ start sync ...")
        addUpdatingProcess()
        completion?()
    }
    
    func endSyns(_ completion: (() -> Void)? = nil) {
        enablePair()
        print("ZHJ end sync ...")
        completion?()
        removeUpdatingProcess()
    }
    
    func readDeviceConfig(_ completion: SequencerCompletion? = nil) {
        deviceConfigProcessor.readDeviceConfig { config in
            //print("### readDeviceConfig \(config) \(config.notice) ...")
            self.deviceConfig = config
            completion?()
        }
    }
    
    func messageSwitch(_ completion: SequencerCompletion? = nil) {
        if deviceConfig.notice {
            completion?()
            return
        }
        let config = deviceConfig
        config.notice = true
        deviceConfigProcessor.writeDeviceConfig(config, setHandle: { result in
            print("### writeDeviceConfig \(config.notice) \(result == .correct)")
            self.deviceConfig.notice = config.notice
            completion?()
        })
    }
}



// MARK: - ZHJ SDK Connections
extension TrusangManager {
    func enablePair(_ completion: (() -> Void)? = nil) {
        enablePairProcessor.enablePair { result in
            if result == .correct {
                print("ZHJ enablePair correct \(result)")
                completion?()
                return
            }
            print("ZHJ enablePair error \(result)")
            completion?()
        }
    }
    
    func autoReconnect() {
        connectionDelegate?.willStartConnecting()
        btProvider.autoReconnect(success: { [self] p in
            print("ZHJ Reconnect done \(p)")
            isConnected = true
            connectionDelegate?.didEndConnecting(succes: true, descrition: "Success")
            afterConnectionSyns()
        }) { [self] (p, err) in
            print("ZHJ Reconnect failed \(p) \(String(describing: err))")
            connectionDelegate?.didEndConnecting(succes: false, descrition: err?.localizedDescription ?? "nil")
        }
    }
    
    func disconnectDeviceFully() {
        wFSequencer.breakAll()
        isConnected = false
        wFSequencer.add(.removeAutoReconnect)
        wFSequencer.add(.disconnectDevice)
    }
    
    func removeAutoReconnect(_ completion: (() -> Void)? = nil) {
        btProvider.removeAutoReconnectDevice()
        print("ZHJ removeAutoReconnectDevice")
        completion?()
    }
    
    func disconnectDevice(_ completion: (() -> Void)? = nil) {
        connectionDelegate?.willDisconnect?()
        btProvider.disconnectDevice { p in
            print("ZHJ disconnectDevice \(p)")
            completion?()
            self.connectionDelegate?.didDisconnect?()
        }
    }
    
    func connectDevice(_ device: ZHJBTDevice, _ completion: ((Bool)-> Void)? = nil) {
        wFSequencer.breakAll()
        connectionDelegate?.willStartConnecting()
        btProvider.connectDevice(device: device) { [self] p in
            print("ZHJ connectDevice success \(p)")
            isConnected = true
            completion?(true)
            connectionDelegate?.didEndConnecting(succes: true, descrition: device.peripheral?.name ?? "nil")
            afterConnectionSyns()
        } fail: { [self] (p, error) in
            print("ZHJ connectDevice error \(p) \(String(describing: error))")
            completion?(false)
            connectionDelegate?.didEndConnecting(succes: true, descrition: error?.localizedDescription ?? "nil")
        } timeout: { [self] in
            print("ZHJ connectDevice timeout")
            completion?(false)
            connectionDelegate?.didEndConnecting(succes: false, descrition: "ZHJ connectDevice timeout")
        }
    }
    
    func bluetoothPrepare(_ completion: ((Bool) -> Void)? = nil) {
        btProvider.bluetoothProviderManagerStateDidUpdate { [self] state in
            print("ZHJ bluetoothPrepare \(String(describing: state))")
            switch state {
            case .poweredOn:
                print("ZHJ poweredOn")
                autoReconnect()
                // scanningDevices()
                completion?(true)
            case .poweredOff:
                print("ZHJ poweredOff")
                completion?(false)
            case .unsupported:
                print("ZHJ unsupported")
                completion?(false)
            case .resetting:
                print("ZHJ resetting")
                completion?(false)
            case .unauthorized:
                print("ZHJ unauthorized")
                completion?(false)
            case .unknown:
                print("ZHJ unknown")
                completion?(false)
            default:
                completion?(false)
                return
            }
        }
    }
}



extension Double {
    func truncate(places: Int) -> Double {
        if self.isNaN || self.isInfinite{ return 0 }
        let divisor = pow(10.0, Double(places))
        return Double(Int(self * divisor)) / divisor
    }
    
    func getStrValue(places: Int = 1) -> String? {
        return String(self.truncate(places: 1))
    }
}



// MARK: - Extensions
extension SleepPhaseType {
    init(from: ZHJSleepType) {
        switch from {
        case .REM:
            self = .REM
        case .awake:
            self = .REM
        case .begin:
            self = .begin
        case .deep:
            self = .deep
        case .light:
            self = .light
        @unknown default:
            self = .REM
        }
    }
}



extension SleepPhaseModel {
    convenience init(from phase: ZHJSleepDetail) {
        self.init()
        dateTime = phase.dateTime
        duration = phase.duration
        pType = .init(from: ZHJSleepType(rawValue: phase.type) ?? .REM)
    }
}



// MARK: - Convert params to [HealthParameterModel] extension for ListHParameterModel
extension ListHParameterModel {
    /// Initializer for TrusangBluetooth ZHJ params, also convert params to [HealthParameterModel] and saves to varibles pulse, bloodOxygen, bloodPressure, temperature
    init(heartRate hr_: ZHJHeartRate? = nil,
         bloodOxygen bo_: ZHJBloodOxygen? = nil,
         bloodPressure bp_: ZHJBloodPressure? = nil,
         temperature tm_: ZHJTemperature? = nil) {
        if let hr = hr_ {
            pulse = convertParams(heartRate: hr)
        }
        if let bo = bo_ {
            bloodOxygen = convertParams(bloodOxygen: bo)
        }
        if let bp = bp_ {
            bloodPressure = convertParams(bloodPressure: bp)
        }
        if let tm = tm_ {
            temperature = convertParams(temperature: tm)
        }
    }
    
    /// Initializer for TrusangBluetooth ZHJ Detail param, also convert param to [HealthParameterModel] and saves to varibles pulse, bloodOxygen, bloodPressure, temperature
    init(heartRate hr_: ZHJHeartRateDetail? = nil,
         bloodOxygen bo_: ZHJBloodOxygenDetail? = nil,
         bloodPressure bp_: ZHJBloodPressureDetail? = nil,
         temperature tm_: ZHJTemperatureDetail? = nil) {
        if let hr = hr_ {
            let hrList = ZHJHeartRate()
            hrList.details.append(hr)
            pulse = convertParams(heartRate: hrList)//hr)
        }
        if let bo = bo_ {
            let boList = ZHJBloodOxygen()
            boList.details.append(bo)
            bloodOxygen = convertParams(bloodOxygen: boList)
        }
        if let bp = bp_ {
            let bpList = ZHJBloodPressure()
            bpList.details.append(bp)
            bloodPressure = convertParams(bloodPressure: bpList)
        }
        if let tm = tm_ {
            let tmList = ZHJTemperature()
            tmList.details.append(tm)
            temperature = convertParams(temperature: tmList)
        }
    }
    
    func checkIndicByTime(date: Date?) -> Bool {
        guard let date = date,
              (date.compare(Date()) == .orderedAscending || date.compare(Date()) == .orderedSame) else { return false }
        return true
    }
    
    /// Converts ZHJHeartRate  to [HealthParameterModel]
    /// - Returns: list of parameters - [HealthParameterModel]
    func convertParams(heartRate: ZHJHeartRate) -> [HealthParameterModel] {
        var hpm: [HealthParameterModel] = []
        //print("### conv \(heartRate.details.count) \(heartRate.details)")
        heartRate.details.enumerated().forEach { key, zhjParam in
            //print("### conv heartRate \(key) \(zhjParam.dateTime) \(zhjParam.HR)")
            guard checkIndicByTime(date: zhjParam.dateTime.toDate()) else { return }
            //print("### conv heartRate pass \(date.minutesDiff(with: Date())) \(key) \(zhjParam.dateTime) \(zhjParam.HR)")
            hpm.append(HealthParameterModel(value: Float(zhjParam.HR), date: zhjParam.dateTime))
        }
        return hpm
    }
    
    /// Converts ZHJBloodOxygen  to [HealthParameterModel]
    /// - Returns: list of parameters - [HealthParameterModel]
    func convertParams(bloodOxygen: ZHJBloodOxygen) -> [HealthParameterModel] {
        var hpm: [HealthParameterModel] = []
        bloodOxygen.details.forEach { zhjParam in
            guard checkIndicByTime(date: zhjParam.dateTime.toDate()) else { return }
            hpm.append(HealthParameterModel(value: Float(zhjParam.BO), date: zhjParam.dateTime))
        }
        return hpm
    }
    
    /// Converts ZHJBloodPressure  to [HealthParameterModel]
    /// - Returns: list of parameters - [HealthParameterModel]
    func convertParams(bloodPressure: ZHJBloodPressure) -> [HealthParameterModel] {
        var hpm: [HealthParameterModel] = []
        bloodPressure.details.forEach { zhjParam in
            guard checkIndicByTime(date: zhjParam.dateTime.toDate()) else { return }
            hpm.append(HealthParameterModel(value: Float(zhjParam.SBP), additionalValue: Float(zhjParam.DBP), date: zhjParam.dateTime))
        }
        return hpm
    }
    
    /// Converts ZHJTemperature  to [HealthParameterModel]
    /// - Returns: list of parameters - [HealthParameterModel]
    func convertParams(temperature: ZHJTemperature) -> [HealthParameterModel] {
        var hpm: [HealthParameterModel] = []
        temperature.details.forEach { zhjParam in
            let corTemp = zhjParam.wristTemperature > 0 ? (Double(zhjParam.wristTemperature)/100.0).truncate(places: 1) :  (Double(zhjParam.headTemperature)/100.0).truncate(places: 1)
            guard checkIndicByTime(date: zhjParam.dateTime.toDate()) else { return }
            hpm.append(HealthParameterModel(value: Float(corTemp), date: zhjParam.dateTime))
        }
        return hpm
    }
}



// MARK: - Tests
/*
extension TrusangManager: TrusangConnectionDelegate {
    func didUpdateScanning(devices: [ZHJBTDevice]) {
        print("ZHJ del didUpdateScanning ZHJBTDevice \(devices) ...")
        if let dv = devices.first?.peripheral, connectedDeviceZHJ == nil {
            TrusangManager.shared.connect(device: dv)
        }
    }
    
    func willStartScanning() {
        print("ZHJ del willStartScanning ...")
    }
    
    func didUpdateScanning(devices: [CBPeripheral]) {
        print("ZHJ del didUpdateScanning CBPeripheral \(devices) ...")
    }
    
    func willStartConnecting() {
        print("ZHJ del willStartConnecting ...")
    }
    
    func didEndConnecting(succes: Bool, descrition: String) {
        print("ZHJ del didEndConnecting \(succes) \(descrition) ...")
        // disconnectDeviceFully()
    }
    
    func willDisconnect() {
        print("ZHJ del willDisconnect ...")
    }
    
    func didDisconnect() {
        print("ZHJ del didDisconnect ...")
    }
}

extension TrusangManager: TrusangDataProcessingDelegate {
    func willStartDeviceInfoSync() {
        print("ZHJ del willStartDeviceInfoSync ...")
    }
    
    func didEndDeviceInfoSync() {
        print("ZHJ del didEndDeviceInfoSync ...")
    }
    
    func willStartDataReading() {
        print("ZHJ del willStartDataReading ...")
    }
    
    func updatedDataReadingProcess(percent: Float) {
        print("ZHJ del updatedDataReadingProcess \(percent) % ...")
        print("ZHJ del updatedDataReadingProcess \(dataProcessingSequence) ...")
        print("ZHJ del updatedDataReadingProcess \(dataProcessingAmount) ...")
    }
    
    func didEndDataReading() {
        print("ZHJ del didEndDataReading ...")
    }
    
    func didUpdate(batteryPower: Int) {
        print("ZHJ del didUpdate batteryPower \(batteryPower) % ...")
    }
}
*/
