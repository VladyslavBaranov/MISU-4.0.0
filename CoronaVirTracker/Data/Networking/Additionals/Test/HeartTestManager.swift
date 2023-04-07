//
//  HeartTestManager.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 27.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

struct HeartTestModel: Codable {
	var pain: Double
	var smoke: Bool
	var unconscious: Bool
	var dyspneic: Bool
	var edema: Double
	var diabetes: Double
}

struct HeartTestResponseModel: Decodable {
	var result: Double
}

final class HeartTestManager {
	
	static let shared = HeartTestManager()
	
	func requestResult(_ model: HeartTestModel, completion: @escaping (HeartTestResponseModel?) -> ()) {
		
		guard let url = URL(string: "https://misu.pp.ua/api/cardio") else {
			completion(nil)
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = try? JSONEncoder().encode(model)
		if let token = KeychainUtility.getCurrentUserToken() {
			request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
		}
		
		let task = URLSession.shared.dataTask(with: request) { data, _, err in
			if err != nil {
				completion(nil)
				return
			}
			guard let data = data else {
				completion(nil)
				return
			}
			guard let model = try? JSONDecoder().decode(HeartTestResponseModel.self, from: data) else {
				completion(nil)
				return
			}
			completion(model)
		}
		task.resume()
	}
}
