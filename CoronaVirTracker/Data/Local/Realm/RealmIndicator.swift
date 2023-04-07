//
//  RealmIndicator.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 02.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import RealmSwift

class RealmIndicator: Object {
	
	@Persisted var indicatorTypeIntValue: Int
	@Persisted var value: Double
	@Persisted var additionalValue: Double?
	@Persisted var date: Date
	
	@Persisted var isSync: Bool
	
	var indicator: __HealthIndicatorType {
		__HealthIndicatorType(rawValue: indicatorTypeIntValue)!
	}
}

extension RealmIndicator {
	static func getIndicators(for type: __HealthIndicatorType) -> [RealmIndicator] {
		guard let realm = try? Realm() else { return [] }
		let indicators = realm.objects(RealmIndicator.self)
			.where({ $0.indicatorTypeIntValue == type.rawValue })
		return Array(indicators)
	}
    static func getAllNotSync(for type: __HealthIndicatorType) -> [RealmIndicator] {
		guard let realm = try? Realm() else { return [] }
		let indicators = realm.objects(RealmIndicator.self).where({ ind in
            !ind.isSync && ind.indicatorTypeIntValue == type.rawValue
		})
		return Array(indicators)
	}
    static func filterIndicators(_ indicators: [RealmIndicator], intervals: [DateInterval]) -> [GraphSample] {
        var samples: [GraphSample] = []
        for (i, interval) in intervals.enumerated() {
            var indicators2 = [RealmIndicator]()
            var sample: GraphSample!
            for indicator in indicators {
                if interval.contains(indicator.date) {
                    indicators2.append(indicator)
                }
            }
            sample = .init(index: i, interval: interval, indicators: indicators2)
            samples.append(sample)
        }
        return samples
    }
}

extension RealmIndicator {
	
    static func insertBulk(_ indicators: [_HealthIndicator], type: __HealthIndicatorType) {
		guard let realm = try? Realm() else { return }
        let dates = realm.objects(RealmIndicator.self)
            .where { $0.indicatorTypeIntValue == type.rawValue }
            .map { $0.date }
        
		for indicator in indicators {
			let _indicator = RealmIndicator()
			_indicator.isSync = true
			_indicator.date = indicator.date
			_indicator.value = indicator.value
			_indicator.additionalValue = indicator.additionalValue
			_indicator.indicatorTypeIntValue = indicator.type.rawValue
            
            realm.writeAsync {
                if !dates.contains(indicator.date) {
                    realm.add(_indicator)
                }
            }
        }
    }
    
    static func insertBulk(_ indicators: [RealmIndicator], type: __HealthIndicatorType) {
        guard let realm = try? Realm() else { return }
        let dates = realm.objects(RealmIndicator.self)
            .where { $0.indicatorTypeIntValue == type.rawValue }
            .map { $0.date }
        for indicator in indicators {
            do {
                try realm.write {
                    if !dates.contains(indicator.date) {
                        realm.add(indicator)
                    }
                }
            } catch {}
        }
    }
	
	static func insert(_ indicator: _HealthIndicator) {
		guard let realm = try? Realm() else { return }
        
        let latestDateForType = realm.objects(RealmIndicator.self)
            .where { $0.indicatorTypeIntValue == indicator.type.rawValue }
            .max(of: \.date)
        
        let _indicator = RealmIndicator()
        _indicator.isSync = false
        _indicator.date = indicator.date
        _indicator.value = indicator.value
        _indicator.additionalValue = indicator.additionalValue
        _indicator.indicatorTypeIntValue = indicator.type.rawValue
        
        do {
            try realm.write {
                if latestDateForType == nil {
                    realm.add(_indicator)
                } else {
                    if indicator.date > latestDateForType! {
                        realm.add(_indicator)
                    }
                }
            }
        } catch {}
    }
}

extension RealmIndicator {
	func ensureSync() {
		guard let realm = try? Realm() else { return }
		do {
			try realm.write { [weak self] in
				self?.isSync = true
			}
		} catch {}
	}
}

extension RealmIndicator {
    static func clear() {
        let realm = try! Realm()
        let indicators = realm.objects(RealmIndicator.self)
        realm.writeAsync {
            for indicator in indicators {
                realm.delete(indicator)
            }
        }
    }
    static func clear(type: __HealthIndicatorType) {
        let realm = try! Realm()
        let indicators = realm.objects(RealmIndicator.self).where { $0.indicatorTypeIntValue == type.rawValue }
        realm.writeAsync {
            for indicator in indicators {
                realm.delete(indicator)
            }
        }
    }
}

#if DEBUG

extension RealmIndicator {
    
    static func observeStorage() {
        let targetIndicators: [
            __HealthIndicatorType
        ] = [.pressure, .temperature, .heartrate]
        for type in targetIndicators {
            let ind = RealmIndicator.getIndicators(for: type)
            let notSync = ind.filter { !$0.isSync }
            print(type, ind.count, notSync.count)
        }
    }
    
    static func ensureAllSync() {
        let realm = try! Realm()
        let objects = realm.objects(RealmIndicator.self)
        for obj in objects {
            do {
                try realm.write {
                    obj.isSync = true
                }
            } catch {}
        }
    }
    
    static func log(for type: __HealthIndicatorType) {
        let realm = try! Realm()
        let objects = realm.objects(RealmIndicator.self)
            .where { $0.indicatorTypeIntValue == type.rawValue }
            .sorted(by: \.date)
        for obj in objects {
            print(obj.value, obj.date, obj.isSync)
        }
    }
}

#endif

extension Array where Element == RealmIndicator {
    func filtered(with interval: DateInterval) -> [RealmIndicator] {
        return filter { $0.date >= interval.start && $0.date <= interval.end }
    }
    func averageValue() -> Double {
        var sum = 0.0
        for indicator in self {
            sum += indicator.value
        }
        return sum / Double(count)
    }
    func averageAdditionalValue() -> Double {
        var sum = 0.0
        for indicator in self {
            sum += indicator.additionalValue ?? -1
        }
        return sum / Double(count)
    }
}
