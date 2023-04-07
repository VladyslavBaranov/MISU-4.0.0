//
//  UsefullEnumUtils.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 10.03.2021.
//  Copyright © 2021 CVTCompany. All rights reserved.
//

import UIKit

// MARK: - General Enum Kit
protocol EnumKit {}

extension EnumKit {
    var key: String {
        return String(describing: self)
    }
}

extension EnumKit where Self: CaseIterable {
    static var allKeys: [String] {
        return Self.allCases.map { elem in
            return elem.key
        }
    }
}
