//
//  IndicatorGraphView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 11.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct Indicator {
    var value: Double
    var date: Date
    
    static func create(_ value: Double, date: String) -> Indicator {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: date) ?? Date()
        return .init(value: value, date: date)
    }
    
    static func filterIndicators(_ indicators: [Indicator], intervals: [DateInterval]) -> [GraphSample] {
        var samples: [GraphSample] = []
        for (i, interval) in intervals.enumerated() {
            var indicators2 = [Indicator]()
            var sample: GraphSample!
            for indicator in indicators {
                if interval.contains(indicator.date) {
                    indicators2.append(indicator)
                }
            }
            // sample = .init(index: i, interval: interval, indicators: indicators2)
            samples.append(sample)
        }
        return samples
    }
    
    static func samples() -> [Indicator] {
        [
            .create(8, date: "2022-10-16 01:00:00"),
            .create(2, date: "2022-10-16 05:10:00"),
            .create(4, date: "2022-10-16 07:00:00"),
            .create(5, date: "2022-10-16 09:00:00"),
            .create(5, date: "2022-10-16 11:40:00"),
            .create(6, date: "2022-10-16 13:00:00"),
            .create(10, date: "2022-10-16 15:00:00"),
            .create(7, date: "2022-10-16 17:00:00"),
            .create(4, date: "2022-10-16 19:00:00"),
        ]
    }
}

struct IndicatorGraphView: UIViewRepresentable {
    
    let indicatorType: __HealthIndicatorType
    @Binding var mode: Int
    
    func makeUIView(context: Context) -> IndicatorGraph {
        let verticalValues: [Int]
        switch indicatorType {
        case .pressure:
            verticalValues = [40, 80, 120, 160, 200]
        case .heartrate:
            verticalValues = [60, 70, 80, 90, 100]
        case .sugar:
            verticalValues = [2, 4, 6, 8, 10]
        case .insuline:
            verticalValues = [5, 10, 15, 20, 15]
        case .oxygen:
            verticalValues = [80, 85, 90, 95, 100]
        case .activity:
            verticalValues = [0, 1000, 2000, 3000, 4000]
        default:
            verticalValues = [35, 36, 37, 38, 39]
        }
        let view = IndicatorGraph(verticalValues: verticalValues, indicatorType: indicatorType)
        view.backgroundColor = .clear
        view.mode = .day
        let week = Date().getStartEndOfWeek()!.breakPeriod(interval: 10)
        let samples = RealmIndicator.filterIndicators(
            RealmIndicator.getIndicators(for: indicatorType),
            intervals: week
        )
        view.samples = [samples]
        
        // dump(samples)
        
        return view
    }
    
    func updateUIView(_ uiView: IndicatorGraph, context: Context) {
        switch mode {
        case 0:
            uiView.mode = .day
        case 1:
            uiView.mode = .week
        case 2:
            uiView.mode = .month
        default:
            uiView.mode = .year
        }
        
    }
    
    typealias UIViewType = IndicatorGraph
    
    
}
