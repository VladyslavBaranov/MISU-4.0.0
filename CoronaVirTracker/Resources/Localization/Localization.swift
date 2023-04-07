//
//  Localization.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 12.07.2022.
//

import Foundation

struct Localizer {
    
    static func menuString(_ key: MenuLocalizationKey) -> String {
        Bundle.main.localizedString(forKey: key.rawValue, value: nil, table: "LocalizableMenu")
    }
    
    static func assistantString(_ key: String) -> String {
        Bundle.main.localizedString(forKey: key, value: nil, table: "LocalizableMenu")
    }
    
    static func watchString(_ key: String) -> String {
        Bundle.main.localizedString(forKey: key, value: nil, table: "LocalizableMenu")
    }
}

func locStr(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}

