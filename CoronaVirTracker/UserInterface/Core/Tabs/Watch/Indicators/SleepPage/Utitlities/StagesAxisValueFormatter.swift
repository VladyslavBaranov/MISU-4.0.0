//
//  StagesAxisValueFormatter.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 16.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import Foundation
import Charts

class StagesAxisValueFormatter: NSObject, AxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch value {
        case 0.0:
            return "DEEP"
        case 1.0:
            return "LIGHT"
        case 2.0:
            return "REM";
        case 3.0:
            return "WAKE";
        default:
            return ""
        }
    }
}
