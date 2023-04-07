//
//  SleepModel.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 24.07.2021.
//  Copyright © 2021 CVTCompany. All rights reserved.
//

import Foundation
import YCProductSDK
import TrusangBluetooth

class RecommendationSleepModel: Decodable, Equatable {
    var title: String?
    var subtitle: String?
    var text: String?
    var preImageURL: String?
    var fullImageURL: String?
    
    enum Keys: String, CodingKey {
        case title = "title"
        case subtitle = "subtitle"
        case text = "text"
        case preImageURL = "pre_image"
        case fullImageURL = "full_image"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        title = try? container.decode(forKey: .title)
        subtitle = try? container.decode(forKey: .subtitle)
        text = try? container.decode(forKey: .text)
        preImageURL = try? container.decode(forKey: .preImageURL)
        fullImageURL = try? container.decode(forKey: .fullImageURL)
    }
    
    static func == (lhs: RecommendationSleepModel, rhs: RecommendationSleepModel) -> Bool {
        return lhs.title == rhs.title &&
               lhs.subtitle == rhs.subtitle &&
               lhs.text == rhs.text &&
               lhs.preImageURL == rhs.preImageURL &&
               lhs.fullImageURL == rhs.fullImageURL
    }
}



// MARK: - Phase Type
enum SleepPhaseType: String, EnumKit, CaseIterable {
    case begin = "begin"
    case light = "light"
    case deep = "deep"
    case REM = "rem"
    case awake = "awake"
    
    var localized: String {
        return NSLocalizedString(title, comment: "")
    }
    
    var title: String {
        switch self {
        case .awake:
            return "Awake"
        case .REM:
            return "REM"
        case .begin:
            return "Begin"
        case .deep:
            return "Deep"
        case .light:
            return "Light"
        }
    }

}



// MARK: - Phase Model
class SleepPhaseModel: Decodable {
    var id: Int = -1
    var dateTime: String?
    var duration: Int?
    
    var date: Date? {
        return dateTime?.toDate(local: false, isGMT: true)
    }
    
    var decoratedTime: String? {
        return date?.getTimeString(zeroCalendar: true)
    }
    
    var decoratedEndTime: String? {
        guard let dr = duration else { return decoratedTime }
        return date?.next(withComponent: .minute, count: dr)?.getTimeString(zeroCalendar: true)
    }
    
    func decoratedTimeBy(percent: Float) -> String? {
        guard var dr = duration else { return decoratedTime }
        dr = Int(Float(dr) * percent)
        return date?.next(withComponent: .minute, count: dr)?.getTimeString(zeroCalendar: true)
    }
    
    var pType: SleepPhaseType? /*{
        guard let tp = typeInt else { return nil }
        return SleepPhaseType(rawValue: tp)
    }*/
    
    enum Keys: String, CodingKey {
        case id = "id"
        case dateTime = "date"
        case duration = "duration"
        case typeStr = "type"
    }
    
    init() { }
    
    func encode() -> Parameters {
        let container = KeyedCustomEncoderContainer(keyedBy: Keys.self)
        
        try? container.updateValue(dateTime, forKey: .dateTime)
        try? container.updateValue(duration, forKey: .duration)
        try? container.updateValue(pType?.rawValue, forKey: .typeStr)
        
        print("SLEEP: \(container.dictionary)")
        
        return container.dictionary
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = (try? container.decode(type(of: id).self, forKey: .id)) ?? -1
        dateTime = try? container.decode(type(of: dateTime).self, forKey: .dateTime)
        duration = try? container.decode(type(of: duration).self, forKey: .duration)
        if let typestr = try? container.decode(String.self, forKey: .typeStr) {
            pType = SleepPhaseType(rawValue: typestr)
        }
    }
}

extension SleepPhaseModel: Equatable {
    public static func == (lhs: SleepPhaseModel, rhs: SleepPhaseModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.dateTime == rhs.dateTime &&
               lhs.duration == rhs.duration &&
               lhs.pType == rhs.pType
    }
}



// MARK: - Sleep Model
public class SleepModel: Decodable {
    
    enum Keys: String, CodingKey {
        case id = "id"
        case dateTime = "date"
        case beginDuration = "begin"
        case REMDuration = "rem"
        case lightDuration = "light"
        case deepDuration = "deep"
        case awakeDuration = "awake"
        case details = "details"
    }
    
    var id: Int = -1
    var dateTime: String?
    var beginDuration: Int?
    var REMDuration: Int?
    var lightDuration: Int?
    var deepDuration: Int?
    var awakeDuration: Int?
    var details: [SleepPhaseModel] = []
    
    var totalDuration: Int {
        return _beginDuration + _REMDuration + _lightDuration + _deepDuration + _awakeDuration
    }
    
    private var _beginDuration: Int {
        if let beginDuration = beginDuration, beginDuration > 0 { return beginDuration }
        return getDurationBy(pType: .begin)
    }
    private var _REMDuration: Int {
        if let remDuration = REMDuration, remDuration > 0 { return remDuration }
        return getDurationBy(pType: .REM)
    }
    private var _lightDuration: Int {
        if let lightDuration = lightDuration, lightDuration > 0 { return lightDuration }
        return getDurationBy(pType: .light)
    }
    private var _deepDuration: Int {
        if let deepDuration = deepDuration, deepDuration > 0 { return deepDuration }
        return getDurationBy(pType: .deep)
    }
    private var _awakeDuration: Int {
        if let awakeDuration = awakeDuration, awakeDuration > 0 { return awakeDuration }
        return getDurationBy(pType: .awake)
    }
    
    private var date: Date? {
        return dateTime?.toDate()
    }
    
    var uId: Int? = nil
    
    init() { }
    
    init(date dt: Date, uId _uID: Int? = nil) {
        dateTime = dt.getDateForRequest()
        uId = _uID
    }
    
    func encodeForURL() -> Parameters {
        let container = KeyedCustomEncoderContainer(keyedBy: Keys.self)
        
        try? container.updateValue(dateTime, forKey: .dateTime)
        try? container.updateValue(uId, forKey: .id)
        return container.dictionary
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = (try? container.decode(type(of: id).self, forKey: .id)) ?? -1
        dateTime = try? container.decode(type(of: dateTime).self, forKey: .dateTime)
        beginDuration = try? container.decode(type(of: beginDuration).self, forKey: .beginDuration)
        REMDuration = try? container.decode(type(of: REMDuration).self, forKey: .REMDuration)
        lightDuration = try? container.decode(type(of: lightDuration).self, forKey: .lightDuration)
        deepDuration = try? container.decode(type(of: deepDuration).self, forKey: .deepDuration)
        awakeDuration = try? container.decode(type(of: awakeDuration).self, forKey: .awakeDuration)
        details = (try? container.decode(type(of: details).self, forKey: .details)) ?? []
    }
    
    func encode() -> Parameters {
        let container = KeyedCustomEncoderContainer(keyedBy: Keys.self)
        
        try? container.updateValue(dateTime, forKey: .dateTime)
        try? container.updateValue(beginDuration, forKey: .beginDuration)
        try? container.updateValue(beginDuration, forKey: .beginDuration)
        try? container.updateValue(REMDuration, forKey: .REMDuration)
        try? container.updateValue(lightDuration, forKey: .lightDuration)
        try? container.updateValue(deepDuration, forKey: .deepDuration)
        try? container.updateValue(awakeDuration, forKey: .awakeDuration)
        try? container.updateValue(details.map { m in return m.encode() }, forKey: .details)
        return container.dictionary
    }
    
    func getDurationBy(pType: SleepPhaseType) -> Int {
        return details.reduce(into: Int()) { duration, model in
			if model.pType == pType {
				duration += model.duration ?? 0
			}
        }
    }
}

extension SleepModel: Equatable {
    public static func == (lhs: SleepModel, rhs: SleepModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.dateTime == rhs.dateTime &&
               lhs.beginDuration == rhs.beginDuration &&
               lhs.REMDuration == rhs.REMDuration &&
               lhs.lightDuration == rhs.lightDuration &&
               lhs.deepDuration == rhs.deepDuration &&
               lhs.awakeDuration == rhs.awakeDuration &&
               lhs.details == rhs.details
    }
}

extension SleepModel {
    convenience init(from sleep: YCHealthDataSleep) {
        self.init()
        details = sleep.sleepDetailDatas.map({ data in
            return SleepPhaseModel(from: data)
        })
        
        REMDuration = sleep.remSleepMinutes == 0 ? _REMDuration : sleep.remSleepMinutes
        lightDuration = sleep.lightSleepMinutes == 0 ? _lightDuration : sleep.lightSleepMinutes
        deepDuration = sleep.deepSleepMinutes == 0 ? _deepDuration : sleep.deepSleepMinutes
        
        dateTime = sleep.startTimeStamp.getDate().getTimeDateForRequest()
    }
}

extension SleepModel {
    convenience init(from sleep: ZHJSleep, dateStr: String?) {
        self.init()
        details = sleep.details.map({ dt in
            return SleepPhaseModel(from: dt)
        })
        
        beginDuration = sleep.beginDuration == 0 ? _beginDuration : sleep.beginDuration
        REMDuration = sleep.REMDuration == 0 ? _REMDuration : sleep.REMDuration
        lightDuration = sleep.lightDuration == 0 ? _lightDuration : sleep.lightDuration
        deepDuration = sleep.deepDuration == 0 ? _deepDuration : sleep.deepDuration
        awakeDuration = sleep.awakeDuration == 0 ? _awakeDuration : sleep.awakeDuration
        
        dateTime = dateStr
    }
}
