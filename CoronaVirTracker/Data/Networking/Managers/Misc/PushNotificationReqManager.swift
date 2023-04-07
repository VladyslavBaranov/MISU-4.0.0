//
//  PushNotificationReqManager.swift
//  CoronaVirTracker
//
//  Created by WH ak on 11.08.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation

struct PushNotificationReqManager: BaseManagerHandler {
    
    private let router = Router<PushNotificationReqApi>()
    static let shared = PushNotificationReqManager()
    private init() {}
    
    func setDevice(deviceId: String, completion: @escaping Success200Completion) {
        let modelToSend = PushNotificationReqModel(deviceId: deviceId)
        router.request(.setDevice(parameters: modelToSend.getParameters())) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, success200Completion: completion)
        }
    }
}
