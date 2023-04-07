//
//  DefaultListManager.swift
//  CoronaVirTracker
//
//  Created by WH ak on 20.08.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation

struct DefaultListManager: BaseManagerHandler {
    private let router = Router<DefaultListsApi>()
    static let shared = DefaultListManager()
    private init() {}
    
    func getConstant(_ type: ConstantsEnum, _ completion: @escaping ResultCompletion<[ConstantsModel]>) {
        router.request(.getConstant(type)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getPositions(completion: @escaping ResultCompletion<[DoctorPositionModel]>) {
        router.request(.getPositions) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getSymptoms(completion: @escaping ResultCompletion<[SymptomModel]>) {
        router.request(.getSymptoms) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}
