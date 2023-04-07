//
//  InAppConfiguration.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 10.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import Foundation

struct InAppConfiguration {
    
    private init() {}
    
    static func readConfigFile() -> Set<String>? {
        guard let path = Bundle.main.url(forResource: "iAps", withExtension: "plist") else { return nil }
        guard let contents = NSDictionary(contentsOf: path) as? [String: AnyObject] else { return nil }
        guard let items = contents["Products"] as? Array<String> else { return nil }
        return Set(items)
    }
    
}
