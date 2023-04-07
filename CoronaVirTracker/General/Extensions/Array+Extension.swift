//
//  Array+Extension.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 19.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
