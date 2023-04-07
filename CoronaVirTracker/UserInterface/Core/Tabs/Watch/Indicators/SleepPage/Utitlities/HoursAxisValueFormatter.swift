//
//  HoursAxisValueFormatter.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 16.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import Foundation
import Charts

class HoursAxisValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    private let dateTime: Date!

    init(startHour: String) {
        dateFormatter.dateFormat = "HH:mm"
        dateTime = dateFormatter.date(from: startHour)
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value == 0.0 {
            return ""
        }
        return dateFormatter.string(from: dateTime.addingTimeInterval(value * 60.0))
    }
}
