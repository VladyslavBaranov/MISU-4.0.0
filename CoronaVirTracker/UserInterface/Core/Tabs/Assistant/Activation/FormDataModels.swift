//
//  FormDataModels.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 29.06.2022.
//

import Foundation

struct GeneralData {
    var fullName: String
    var birthdate: String
    var phoneNumber: String
    var email: String
}

struct AddressData {
    var country: String
    var city: String
    var deliveryMethod: String
    var deliveryAddress: String
}

struct IdentityData {
    var ipn: String
    var passportType: String
    var serialOfPassport: String?
    var passportNumber: String
}

class AssistantActivationState {
    
    static var shared = AssistantActivationState()
    
    var generalData = GeneralData(fullName: "", birthdate: "", phoneNumber: "", email: "")
    var addressData = AddressData(country: "", city: "", deliveryMethod: "", deliveryAddress: "")
    var identityData = IdentityData(ipn: "", passportType: "", passportNumber: "")
    
    
    func toServerModel() -> AssistanceActivationFormModel {
        var model = AssistanceActivationFormModel()
        model.name = generalData.fullName
        model.email = generalData.email
        model.ipn = identityData.ipn
        model.pasport = identityData.passportNumber
        model.phone = generalData.phoneNumber
        model.deliveryInfo.city.label = addressData.city
        model.deliveryInfo.novaposhta.address = addressData.deliveryAddress
        return model
    }
    
}
