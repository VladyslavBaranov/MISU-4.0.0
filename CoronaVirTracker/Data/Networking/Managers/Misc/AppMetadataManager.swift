//
//  AppMetadataManager.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.11.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

struct AppInfoResult: Decodable {
    var results: [AppInfo]
}

struct AppInfo: Decodable {
    var version: String
}

class AppMetadataManager {
    
    static let shared = AppMetadataManager()
    
    func getAppInfoResults(_ completion: @escaping (AppInfoResult?) -> ()) {
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=com.WH.MISU") else {
            completion(nil)
            return
        }
        let req = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: req) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let decoded = try? JSONDecoder().decode(AppInfoResult.self, from: data) else {
                completion(nil)
                return
            }
            completion(decoded)
        }
        task.resume()
    }
}
