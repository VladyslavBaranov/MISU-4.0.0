//
//  AppConfiguration.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 07.01.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import Foundation

struct AppConfiguration {
    static let developmentModeEnabled: Bool = Bundle.main.object(
        forInfoDictionaryKey: "DevelopmentModeEnabled") as? Bool ?? false
    static let misuVersion: Int = Bundle.main.object(
        forInfoDictionaryKey: "MISU-Version") as? Int ?? 1
}
