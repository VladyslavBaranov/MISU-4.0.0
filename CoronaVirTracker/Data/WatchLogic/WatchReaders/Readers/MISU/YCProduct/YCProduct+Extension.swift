//
//  YCProduct+Extension.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 19.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import YCProductSDK


// MARK: - Extensions

extension YCProductState: EnumKit {
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

extension YCHealthDataSleepType {
    var misuType: SleepPhaseType {
        switch self {
        case .unknow:
            return .REM
        case .deepSleep:
            return .deep
        case .lightSleep:
            return .light
        @unknown default:
            return .awake
        }
    }
}

extension SleepPhaseModel {
    convenience init(from phase: YCHealthDataSleepDetail) {
        self.init()
        dateTime = phase.startTimeStamp.getDate().getTimeDateForRequest()
        duration = phase.duration
        pType = phase.sleepType.misuType
    }
}

extension HealthDataController {
    func saveToServer(YCSleepList: [YCHealthDataSleep]?) {
        guard let sleepList = YCSleepList else {
            // print("YCP sleep NIL ERROR ...")
            return
        }
        let misuSleepList = sleepList.map({ SleepModel(from: $0) })
        YCProductManager.shared.sleepHistory = misuSleepList
        saveToServer(sleepList: misuSleepList)
    }
}

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
            // print("YCP convertParams heartRate: TYPE ERROR")
            return []
        }
        return hr.map { sample in
            return .init(
                value: Float(sample.heartRate),
                additionalValue: nil,
                date: sample.startTimeStamp.getDate()
            )
        }
    }
    
    func convertParams(bloodPressure: [Any]) -> [HealthParameterModel] {
        guard let bodyPressure = bloodPressure as? [YCHealthDataBloodPressure] else {
            // print("YCP convertParams bloodPressure: TYPE ERROR")
            return []
        }
        return bodyPressure.map { sample in
            return .init(
                value: Float(sample.systolicBloodPressure),
                additionalValue: Float(sample.diastolicBloodPressure),
                date: sample.startTimeStamp.getDate()
            )
        }
    }
    
    func convertParams(bloodOxygen: [Any]) -> [HealthParameterModel] {
        guard let samples = bloodOxygen as? [YCHealthDataBloodOxygen] else {
            // print("YCP convertParams bloodOxygen: TYPE ERROR")
            return []
        }
        return samples.map { sample in
            return .init(
                value: Float(sample.bloodOxygen),
                additionalValue: nil,
                date: sample.startTimeStamp.getDate()
            )
        }
    }
    
    func convertParams(bodyTemperature: [Any]) -> [HealthParameterModel] {
        guard let samples = bodyTemperature as? [YCHealthDataBodyTemperature] else {
            // print("YCP convertParams bodyTemperature: TYPE ERROR")
            return []
        }
        return samples.map { sample in
            return .init(
                value: Float(sample.temperature),
                additionalValue: nil,
                date: sample.startTimeStamp.getDate()
            )
        }
    }
}

