//
//  MedicalHistoryManager.swift
//  CoronaVirTracker
//
//  Created by WH ak on 15.10.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation

struct MedicalHistoryManager: BaseManagerHandler {
    private let router = Router<MedicalHistoryApi>()
    static let shared = MedicalHistoryManager()
    private init() {}
    
    func illnessHistory(id: Int? = nil, completion: @escaping ResultCompletion<[IllnessModel]>) {
        router.request(.illnessHistory(id: id)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func createIllness(_ illness: IllnessModel, completion: @escaping ResultCompletion<IllnessModel>) {
        router.request(.create(parameters: illness.getParamsDict())) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func updateIllness(_ illness: IllnessModel, completion: @escaping ResultCompletion<IllnessModel>) {
        router.request(.update(id: illness.id, parameters: illness.getParamsDict())) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func deleteIllness(id: Int, completion: @escaping Success200Completion) {
        router.request(.delete(id: id)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, success200Completion: completion)
        }
    }
    
    func confirmConsts(completion: @escaping ResultCompletion<[ConstantsModel]>) {
        router.request(.confirmConsts) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func stateConsts(completion: @escaping ResultCompletion<[ConstantsModel]>) {
        router.request(.stateConsts) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func illnessList(completion: @escaping ResultCompletion<[IllnessListItemModel]>) {
        router.request(.illnessList) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}
