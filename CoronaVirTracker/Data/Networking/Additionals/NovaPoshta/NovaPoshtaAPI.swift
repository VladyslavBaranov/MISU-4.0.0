//
//  NovaPoshtaAPI.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 27.06.2022.
//

import Foundation

struct NovaPoshtaWarehouseResult: Codable {
    struct Warehouse: Codable {
        var Description: String
    }
    
    var success: Bool
    var data: [Warehouse]
}

final class NovaPoshtaAPI {
    
    static let shared = NovaPoshtaAPI()
    
    private init(){}
    
    func lookForWarehouses(in city: String, completion: @escaping (NovaPoshtaWarehouseResult?) -> ()) {
        let json: [String: Any] = [
            "apiKey": "721ce7bc7ca1155ed4bdc6e3802ea391",
            "modelName": "Address",
            "calledMethod": "getWarehouses",
            "methodProperties": [
                "FindByString" : city,
                "Limit" : "50"
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else { return }
        
        guard let url = URL(string: "https://api.novaposhta.ua/v2.0/json/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let result = try? JSONDecoder().decode(NovaPoshtaWarehouseResult.self, from: data) else {
                completion(nil)
                return
            }
            completion(result)
        }
        
        task.resume()
    }
    
}
