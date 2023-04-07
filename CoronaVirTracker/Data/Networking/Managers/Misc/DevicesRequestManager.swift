//
//  DevicesRequestManager.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 17.02.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

class DevicesRequestManager: BaseManagerHandler {
    private let router = Router<DevicesAPI>()
    static let shared = DevicesRequestManager()
    private init() {}
    
    func getConnectionsHistory(_ completion: @escaping ResultCompletion<PaginatedDevicesList>) {
        router.request(.getConnectionsHistory) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func saveConnection(model: DeviceModel, _ completion: @escaping Success200Completion) {
        router.request(.saveConnection(params: model.encode())) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, success200Completion: completion)
        }
    }
}


