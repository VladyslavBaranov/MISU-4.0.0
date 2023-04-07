//
//  AppleWatchDataReader.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 02.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
import HealthKit

final class AppleWatchDataReader: WatchDataReader {
	
	private var indicatorCounter = 0
	
	private let store = HKHealthStore()
    
    var sleepData: [_RealmSleepIndicatorPhase] = []
	
	func execute() {
		let set = AppleWatchDataReader.getHKTypesToRead()
		store.requestAuthorization(toShare: nil, read: set as? Set) { [weak self] granted, _ in
			if granted {
				self?.runQueriesForPressure(isSystolic: true)
				self?.runQueriesForPressure(isSystolic: false)
				self?.runQuery(for: .temperature)
				self?.runQuery(for: .heartrate)
				self?.runQuery(for: .sugar)
                self?.runQuery(for: .oxygen)
			}
		}
        readSleepData()
	}
    
    func readSleepData() {
        let predicate = HKQuery.predicateForSamples(withStart: Date(timeInterval: -24 * 3600, since: Date()), end: Date())
        let query = HKSampleQuery(
            sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { [weak self] query, samples, err in
            guard let samples = samples else { return }
            
            var phases: [_RealmSleepIndicatorPhase] = []
            
            for sample in samples {
                if let sample = sample as? HKCategorySample {
                    if sample.endDate.isSameDay(with: Date()) || sample.endDate.isSameDay(with: Date().addingTimeInterval(-24 * 3600)) {
                        if let sleepType = HKCategoryValueSleepAnalysis(rawValue: sample.value) {
                            var phase = _RealmSleepIndicatorPhase()
                            phase.start = sample.startDate
                    
                            switch sleepType {
                            case .inBed:
                                phase.type = _RealmSleepIndicatorPhase.SleepType.unspecified.rawValue
                            case .awake:
                                phase.type = _RealmSleepIndicatorPhase.SleepType.awake.rawValue
                            case .asleepCore, .asleepUnspecified:
                                phase.type = _RealmSleepIndicatorPhase.SleepType.light.rawValue
                            case .asleepDeep:
                                phase.type = _RealmSleepIndicatorPhase.SleepType.deep.rawValue
                            case .asleepREM:
                                phase.type = _RealmSleepIndicatorPhase.SleepType.rem.rawValue
                            @unknown default:
                                phase.type = _RealmSleepIndicatorPhase.SleepType.unspecified.rawValue
                            }
                            
                            phases.append(phase)
                        }
                    }
                }
            }
            
            for i in 0..<phases.count - 1 {
                phases[i].duration = phases[i + 1].start.timeIntervalSince(phases[i].start)
            }
            
            self?.sleepData = phases
            
            if let strongSelf = self {
                self?.delegate?.didFinishReadingSleepData(strongSelf)
            }
        }
        store.execute(query)
    }
}

private extension AppleWatchDataReader {
	
	static func getHKTypesToRead() -> NSSet {
		NSSet(array: [
			HKObjectType.categoryType(forIdentifier: .sleepAnalysis) ?? "",
			HKObjectType.quantityType(forIdentifier: .stepCount) ?? "",
			HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic) ?? "",
			HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic) ?? "",
			HKObjectType.quantityType(forIdentifier: .bloodGlucose) ?? "",
			HKObjectType.quantityType(forIdentifier: .heartRate) ?? "",
			HKObjectType.quantityType(forIdentifier: .oxygenSaturation) ?? "",
			HKObjectType.quantityType(forIdentifier: .bodyTemperature) ?? "",
			HKObjectType.quantityType(forIdentifier: .insulinDelivery) ?? "",
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis) ?? ""
		])
	}
	
	func runQueriesForPressure(isSystolic: Bool) {
		let predicate = HKQuery.predicateForSamples(withStart: Date(timeInterval: -24 * 3600, since: Date()), end: Date())
		let query = HKSampleQuery(
			sampleType: .quantityType(forIdentifier: isSystolic ? .bloodPressureSystolic : .bloodPressureDiastolic)!,
			predicate: predicate,
			limit: HKObjectQueryNoLimit,
			sortDescriptors: nil
		) { query, samples, err in
			guard let samples = samples else { return }
			for sample in samples {
				if let sample = sample as? HKQuantitySample {
					if sample.endDate.isSameDay(with: Date()) {
						let indicator = _HealthIndicator()
						indicator.type = .pressure
						indicator.value = sample.quantity.doubleValue(for: .millimeterOfMercury())
						indicator.date = sample.endDate
						
						if isSystolic {
							self.systolicPressureIndicators.append(indicator)
						} else {
							self.diastolicPressureIndicators.append(indicator)
						}
					}
				}
			}
			self.indicatorCounter += 1
			if self.indicatorCounter == 6 {
				self.buildPressureArray()
				self.delegate?.didFinishReadingData(self)
			}
		}
		store.execute(query)
	}
    
    
	
	func runQuery(for type: __HealthIndicatorType) {
		let unit = getHKUnit(for: type)
		let predicate = HKQuery.predicateForSamples(withStart: Date(timeInterval: -24 * 3600, since: Date()), end: Date())
		let query = HKSampleQuery(
			sampleType: getSampleType(for: type),
			predicate: predicate,
			limit: HKObjectQueryNoLimit,
			sortDescriptors: nil
		) { query, samples, err in
			guard let samples = samples else { return }
			
			for sample in samples {
				if let sample = sample as? HKQuantitySample {
                    if sample.endDate.isSameDay(with: Date()) {
                        
                        let indicator = _HealthIndicator()
                        indicator.type = type
                        indicator.value = sample.quantity.doubleValue(for: unit)
                        indicator.date = sample.endDate
                        
                        if type == .activity {
                            self.activityIndicators.append(indicator)
                        } else if type == .temperature {
                            self.temperatureIndicators.append(indicator)
                        } else if type == .heartrate {
                            self.heartrateIndicators.append(indicator)
                        } else if type == .sugar {
                            self.sugarIndicators.append(indicator)
                        } else if type == .oxygen {
                            self.oxygenIndicators.append(indicator)
                        }
                    
					}
				}
			}
			self.indicatorCounter += 1
			if self.indicatorCounter == 5 {
				self.buildPressureArray()
				self.delegate?.didFinishReadingData(self)
			}
		}
		self.store.execute(query)
	}
	
	func buildPressureArray() {
		guard systolicPressureIndicators.count == diastolicPressureIndicators.count else { return }
		for i in 0..<systolicPressureIndicators.count {
			let combinedIndicator = _HealthIndicator()
			combinedIndicator.type = .pressure
			combinedIndicator.value = systolicPressureIndicators.rawArray[i].value
			combinedIndicator.additionalValue = diastolicPressureIndicators.rawArray[i].value
			combinedIndicator.date = systolicPressureIndicators.rawArray[i].date
			pressureIndicators.append(combinedIndicator)
		}
	}
	
	func getSampleType(for indicatorType: __HealthIndicatorType) -> HKSampleType {
		switch indicatorType {
		case .sleep:
			return .categoryType(forIdentifier: .sleepAnalysis)!
		case .activity:
			return .quantityType(forIdentifier: .stepCount)!
		case .sugar:
			return .quantityType(forIdentifier: .bloodGlucose)!
		case .heartrate:
			return .quantityType(forIdentifier: .heartRate)!
		case .oxygen:
			return .quantityType(forIdentifier: .oxygenSaturation)!
		case .temperature:
			return .quantityType(forIdentifier: .bodyTemperature)!
		case .insuline:
			return .quantityType(forIdentifier: .insulinDelivery)!
		default:
			fatalError()
		}
	}
	
	func getHKUnit(for indicatorType: __HealthIndicatorType) -> HKUnit {
		switch indicatorType {
		case .activity:
			return .count()
		case .temperature:
			return .degreeCelsius()
		case .heartrate:
			return HKUnit(from: "count/min")
		case .sugar:
			return HKUnit.moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose).unitDivided(by: HKUnit.liter())
        case .oxygen:
            return .percent()
		default:
			fatalError()
		}
	}
}
