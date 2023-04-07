//
//  RealmSleepIndicator.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 19.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import RealmSwift
import YCProductSDK

struct _RealmSleepIndicatorPhase: Codable {
    var start: Date
    var duration: TimeInterval
    var type: Int
    
    enum SleepType: Int {
        case deep = 0
        case light = 1
        case rem = 2
        case awake = 3
        case unspecified = 4
    }
    
    init() {
        start = Date()
        duration = 0
        type = 0
    }
    
    init(start: Date, duration: TimeInterval, type: Int) {
        self.start = start
        self.duration = duration
        self.type = type
    }
    
    static func getSamples() -> [_RealmSleepIndicatorPhase] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return [
            .init(start: formatter.date(from: "2022-10-20 09:00:00")!, duration: 1800, type: 0),
            .init(start: formatter.date(from: "2022-10-20 09:30:00")!, duration: 3600, type: 1),
            .init(start: formatter.date(from: "2022-10-20 10:30:00")!, duration: 1800, type: 0),
            .init(start: formatter.date(from: "2022-10-20 11:00:00")!, duration: 7200, type: 1),
            .init(start: formatter.date(from: "2022-10-20 13:00:00")!, duration: 4000, type: 0),
            .init(start: formatter.date(from: "2022-10-20 14:00:00")!, duration: 3600, type: 1),
            .init(start: formatter.date(from: "2022-10-20 15:00:00")!, duration: 1000, type: 0),
            .init(start: formatter.date(from: "2022-10-20 16:00:00")!, duration: 3600, type: 1),
            .init(start: formatter.date(from: "2022-10-20 17:00:00")!, duration: 3600, type: 0),
        ]
    }
}

class RealmSleepIndicator: Object {
    
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    
    @Persisted var remDuration: TimeInterval
    @Persisted var awakeCount: Int
    
    @Persisted var phases: Data?
    
    func getPhases() -> [_RealmSleepIndicatorPhase] {
        guard let data = phases else { return [] }
        guard let phases = try? JSONDecoder().decode([_RealmSleepIndicatorPhase].self, from: data) else { return [] }
        return phases
    }
}

extension RealmSleepIndicator {
    convenience init(_ ycModel: YCHealthDataSleep) {
        self.init()
        startDate = Date(timeIntervalSince1970: TimeInterval(ycModel.startTimeStamp))
        endDate = Date(timeIntervalSince1970: TimeInterval(ycModel.endTimeStamp))
        
        remDuration = TimeInterval(ycModel.remSleepMinutes * 60)
        awakeCount = 1
        
        let phases = ycModel.sleepDetailDatas.map { detail in
            let phase = _RealmSleepIndicatorPhase(
                start: Date(timeIntervalSince1970: TimeInterval(detail.startTimeStamp)),
                duration: TimeInterval(detail.duration),
                type: ycGetSleepPhaseType(detail.sleepType)
            )
            return phase
        }
        self.phases = try? JSONEncoder().encode(phases)
    }
    
    convenience init(_ phases: [_RealmSleepIndicatorPhase]) {
        self.init()
        
        if let first = phases.first {
            startDate = first.start
        } else {
            startDate = Date()
        }
        
        if let last = phases.last {
            endDate = last.start.addingTimeInterval(last.duration)
        } else {
            startDate = Date()
        }
        
        remDuration = -1
        awakeCount = -1
        
        self.phases = try? JSONEncoder().encode(phases)
    }
    
    static func getAll() -> [RealmSleepIndicator] {
        let realm = try! Realm()
        return Array(realm.objects(RealmSleepIndicator.self))
    }
    
    func save() {
        let realm = try! Realm()
        let allRecordings = realm.objects(RealmSleepIndicator.self)
        
        if allRecordings.contains(where: { startDate.isBetween($0.startDate, and: $0.endDate) }) { return }
        if allRecordings.contains(where: { endDate.isBetween($0.startDate, and: $0.endDate) }) { return }
        
        do {
            try realm.write {
                realm.add(self)
            }
        } catch {}
    }
    
    static func clear() {
        let realm = try! Realm()
        let all = getAll()
        for obj in all {
            do {
                try realm.write {
                    realm.delete(obj)
                }
            } catch {}
        }
    }
    
    func getDurationString() -> String {
        let interval = Int(startDate.distance(to: endDate))
        let hours = interval / 3600
        let mins = (interval / 60) % 60
        return "\(hours) h \(mins) min"
    }
}

fileprivate extension RealmSleepIndicator {
    func ycGetSleepPhaseType(_ type: YCHealthDataSleepType) -> Int {
        switch type {
        case .deepSleep:
            return 0
        case .lightSleep:
            return 1
        case .unknow:
            return 2
        @unknown default:
            return 2
        }
    }
}

extension Array where Element == _RealmSleepIndicatorPhase {
    func extractForDates(start: Date, end: Date) -> [_RealmSleepIndicatorPhase] {
        filter { element in
            element.start >= start && element.start <= end
        }
    }
}

extension RealmSleepIndicator {
    func getDurationFor(phaseType: _RealmSleepIndicatorPhase.SleepType) -> TimeInterval {
        let durations = getPhases().filter { $0.type == phaseType.rawValue }
        var sum: TimeInterval = 0.0
        for duration in durations {
            sum += duration.duration
        }
        return sum
    }
    func getAwakeCounts() -> Int {
        getPhases().filter { $0.type == _RealmSleepIndicatorPhase.SleepType.awake.rawValue }.count
    }
}
