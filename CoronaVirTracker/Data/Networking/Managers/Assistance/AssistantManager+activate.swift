//
//  AssistantManager+activate.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 30.11.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

struct AssistanceActivationFormModel: Codable {
    struct DeliveryInfo: Codable {
        struct City: Codable {
            var area: String = ""
            var id: String = ""
            var label: String = ""
        }
        struct Novaposhta: Codable {
            var address: String = ""
            var description: String = ""
            var id: String = ""
        }
        var city: City = .init()
        var novaposhta: Novaposhta = .init()
    }
    var deliveryInfo: DeliveryInfo = .init()
    var edit: String = ""
    var email: String = ""
    var familyName: String = ""
    var ipn: String = ""
    var name: String = ""
    var pasport: String = ""
    var passportDate: String = ""
    var phone: String = ""
    var secondName: String = ""
}

struct AssistanceCodeConfirmationFormModel: Codable {
    var phone: String
    var code: String
}

extension AssistantManager {
    func activate(_ model: AssistanceActivationFormModel) {
        guard let data = try? JSONEncoder().encode(model) else { return }
        
        guard let url = URL(string: "https://misu.pp.ua/web/order?status=activate&host=test") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        if let token = KeychainUtility.getCurrentUserToken() {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        let task = URLSession.shared.dataTask(with: request) { _, _, _ in
        }
        task.resume()
    }
    func confirmCode(_ code: String, phone: String) {
        let model = AssistanceCodeConfirmationFormModel(phone: phone, code: code)
        guard let data = try? JSONEncoder().encode(model) else { return }
        
        guard let url = URL(string: "https://misu.pp.ua/web/check") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        if let token = KeychainUtility.getCurrentUserToken() {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { _, _, _ in
        }
        task.resume()
    }
}
