//
//  Models.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 04.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

// PRIVATE STRUCTURES FOR HANDLING INDICATORS COMING FROM SERVER
struct _UploadServerIndicatorModel: Encodable {
    var value: Double
    var date: String
    var additional: Double?
}

extension Array where Element == _UploadServerIndicatorModel {
    func toHealthParameterModels() -> [HealthParameterModel] {
        var models: [HealthParameterModel] = []
        for obj in self {
            var model = HealthParameterModel()
            model.value = Float(obj.value)
            if let add = obj.additional {
                model.additionalValue = Float(add)
            }
            model.date = obj.date
            models.append(model)
        }
        return models
    }
}

struct _UploadServerIndicatorsBulk: Encodable {
    
    var temperature: [_UploadServerIndicatorModel]?
    var pressure: [_UploadServerIndicatorModel]?
    var heartrate: [_UploadServerIndicatorModel]?
    
    func isEmpty() -> Bool {
        if let temperature = temperature {
            return temperature.isEmpty
        }
        if let pressure = pressure {
            return pressure.isEmpty
        }
        return true
    }
    
    mutating func assign(_ indicators: [_UploadServerIndicatorModel], type: __HealthIndicatorType) {
        switch type {
        case .pressure:
            pressure = indicators
        case .temperature:
            temperature = indicators
        default:
            break
        }
    }
    
    mutating func assign(_ indicators: [RealmIndicator], type: __HealthIndicatorType) {
        
        var serverModels: [_UploadServerIndicatorModel] = []
        let formatter = ISO8601DateFormatter()
        
        for indicator in indicators {
            let model = _UploadServerIndicatorModel(
                value: indicator.value,
                date: formatter.string(from: indicator.date),
                additional: indicator.additionalValue
            )
            serverModels.append(model)
        }
        
        switch type {
        case .pressure:
            pressure = serverModels
        case .temperature:
            temperature = serverModels
        default:
            break
        }
    }
    
}

struct _GetServerIndicatorModel: Codable {
    var id: Int
    var value: Double?
    var date: String
    var additional: Double?
    
    func getDate() -> Date {
        var finalString = ""
        var shouldOmit = false
        for char in date {
            if char == "." {
                shouldOmit = true
            } else if char == "Z" {
                shouldOmit = false
            }
            if !shouldOmit {
                finalString.append(char)
            }
        }
        
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: finalString) ?? Date()
    }
}
