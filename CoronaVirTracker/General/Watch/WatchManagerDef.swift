//
//  WatchManagerDef.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 17.12.2021.
//  Copyright © 2021 CVTCompany. All rights reserved.
//

import Foundation
import CoreBluetooth

@objc protocol DeviceConnectionDelegate {
    func willStartScanning()
    func didUpdateScanning(devices: [CBPeripheral])
    
    func willStartConnecting()
    func didEndConnecting(succes: Bool, descrition: String)
    
    @objc optional func willDisconnect()
    @objc optional func didDisconnect()
}

@objc protocol DeviceDataProcessingDelegate {
    @objc optional func willStartDeviceInfoSync()
    @objc optional func didEndDeviceInfoSync()
    
    func willStartDataReading()
    
    func updatedDataReadingProcess(percent: Float)
    @objc optional func didUpdate(batteryPower: Int)
    
    func didEndDataReading()
}

class WatchManager {
    /// Key to store any info about device in UserDefaults
    /// Should be owerriden in inheritance
    var userDefaultKey: String { "userDefaultKey" }
    
    var scanningDeviceDelayTime: TimeInterval { 3.0 }
    
    /// Varible indicates is a device connected or not
    var isConnected: Bool {
        get {
            return UserDefaultsUtils.getBool(key: userDefaultKey) ?? false
        }
        set {
            UserDefaultsUtils.save(value: newValue, key: userDefaultKey)
        }
    }
    
    /// Model of device that is currenly connected. It stores basic information about device
    /// - It does not update automaticly
    var deviceModel: DeviceModel?
    
    /// Varible stors sleep history in dictionary where key is a date and value is a sleep model
    var sleepHistory: [SleepModel] = []
    
    
    /// Flag for updating status of device
    /// - is device currently updating or not
    var isUpdating: Bool = false
    
    /// Count of current updating Processes
    /// - if chenges to 0 than automatically switches isUpdating to false
    /// - if chenges to more than 0 than automatically switches isUpdating to true
    /// - if chenges to less than 0 than chenges itself to 0
    /// - To USAGE use addUpdateProcess or removeUpdateProcess methods
    var updatingProcessesCount: Int = 0 {
        didSet {
            if updatingProcessesCount == 0 { isUpdating = false }
            if updatingProcessesCount > 0 { isUpdating = true }
            if updatingProcessesCount < 0 { updatingProcessesCount = 0 }
        }
    }
    
    /// Adds ONE procces to updatingProcessesCount
    /// - Method to use Process status tools
    func addUpdatingProcess() {
        updatingProcessesCount += 1
    }
    
    /// Removes ONE procces to updatingProcessesCount
    /// - Method to use Process status tools
    func removeUpdatingProcess() {
        updatingProcessesCount -= 1
    }
    
    func scanningDevices() {
        fatalError("Method must be overridden: scanningDevices")
    }
    func connect(device: CBPeripheral) {
        fatalError("Method must be overridden: connect")
    }
    func disconnect(device: CBPeripheral?) {
        fatalError("Method must be overridden: disconnect")
    }
}

// Feature: Add unic methots for retrieving all types of data from gadgets
extension WatchManager {
    /// Method send information about connecting deviceModel to server
    /// - updates date in deviceModel to current
    @objc func saveDeviceConnection() {
        deviceModel?.date = Date()
        guard let dmodel = deviceModel else {
            print("DEVICE save ERROR: Device is nil")
            return
        }
        DevicesRequestManager.shared.saveConnection(model: dmodel) { success, error in
            print("DEVICE save request:", success)
            print("DEVICE save request ERROR:", error as Any)
        }
    }
    
    /// Unique methot for getting all data from device
    /// - For implementation of method it should be overridden in child Class
    @objc func updateAllData() {
        fatalError("Method must be overridden: updateAllData")
    }
}
