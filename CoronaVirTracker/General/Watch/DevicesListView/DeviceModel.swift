//
//  DeviceModel.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 17.02.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import UIKit

class DeviceModel: Decodable {
    var id: Int = -1
    var name: String?
    var dateTime: String?
    var date: Date?
    var mac: String?
    var phone_mac: String?
    
    enum Keys: String, CodingKey {
        case id = "id"
        case name = "name"
        case dateTime = "dateTime"
        case date = "date"
        case mac = "mac"
        case phone_mac = "phone_mac"
    }
    
    init(name nm: String, date dt: Date = Date(), dmac: String) {
        name = nm
        dateTime = dt.getTimeDateForRequest()
        date = dt
        mac = dmac
        phone_mac = UIDevice.current.identifierForVendor?.uuidString
        print("=== DEVICE phone mac:", phone_mac as Any)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = (try? container.decode(forKey: .id)) ?? -1
        name = try? container.decode(forKey: .name)
        dateTime = try? container.decode(forKey: .dateTime)
        date = try? container.decode(forKey: .date)
        mac = try? container.decode(forKey: .mac)
        phone_mac = try? container.decode(forKey: .phone_mac)
    }
    
    func encode() -> Parameters {
        let container = KeyedCustomEncoderContainer(keyedBy: Keys.self)
        
        try? container.updateValue(name, forKey: .name)
        try? container.updateValue(dateTime, forKey: .dateTime)
        try? container.updateValue(mac, forKey: .mac)
        try? container.updateValue(phone_mac, forKey: .phone_mac)
        
        return container.dictionary
    }
}

class PaginatedDevicesList: PaginatedModel<DeviceModel> { }
