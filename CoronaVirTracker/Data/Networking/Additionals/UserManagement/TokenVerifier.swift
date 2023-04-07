//
//  TokenVerifier.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 29.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

struct _TokenVerifierResponseModel: Decodable {
	var detail: String
}

final class TokenVerifier {
	
	static let shared = TokenVerifier()
	
	func verify(_ token: String, completion: @escaping (Bool) -> ()) {
		guard let url = URL(string: "https://misu.pp.ua/api/check") else {
			completion(false)
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, _, err in
			guard err == nil else {
				return
			}
			guard let data = data else {
				return
			}
			guard let response = try? JSONDecoder().decode(
				_TokenVerifierResponseModel.self, from: data) else {
				completion(false)
				return
			}
			completion(response.detail == "Token is valid")
		}
		task.resume()
	}
}
