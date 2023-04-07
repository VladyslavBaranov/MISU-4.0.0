//
//  HealthParamsManager.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 08.11.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation

struct HealthParamsManager: BaseManagerHandler {
    private let router = Router<HealthParamsApi>()
    
    static let shared = HealthParamsManager()
    
    private init() {}
    
    func getLast(uId: Int?, completion: @escaping ResultCompletion<Health4Params>) {
        router.request(.getLast(uId: uId) ) { (data, response, error) in
            //handleResponse(data: data, response: response, error: error, successHandleCompletion: debugSuccessHandleCompletion(), failureCompletion: debugFailureHandleCompletion, completion: completion)
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func calibrate(_ model: IndicatorCalibrationModel, completion: @escaping ResultCompletion<IndicatorCalibrationModel>) {
        router.request(.calibrate(params: model.encode())) { (data, response, error) in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getCalibrate(completion: @escaping ResultCompletion<[IndicatorCalibrationModel]>) -> URLSessionTask? {
        return router.requestWithReturn(.getCalibrate) { (data, response, error) in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getStatictic(userId: Int? = nil, type: HealthParamsEnum, range: HealthParamsEnum.StaticticRange,
                      completion: @escaping ResultCompletion<[HealthParameterModel]>) {
        router.request(.getStatictic(userId: userId, name: type.nameVorRequest, range: range.rawValue)) { (data, response, error) in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
        
    }
    
    func temperatureTest(completion: @escaping ResultCompletion<[HealthParameterModel]>) {
        router.request(.temperatureTest) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
            /*handleResponse(data: data, response: response, error: error,
                           successHandleCompletion: debugSuccessHandleCompletion(),
                           failureCompletion: debugFailureHandleCompletion,
                           completion: completion)*/
        }
    }
    
    func writeListHParams(model: ListHParameterModel, completion: @escaping Success200Completion) {
        router.request(.writeList(params: model.encodeForRequest())) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, success200Completion: completion)
        }
    }
    
    func getHealthParamsHistory(type: HealthParamsEnum, profileId: Int? = nil, completion: @escaping ResultCompletion<[HealthParameterModel]>) {
        let api: HealthParamsApi = {
            switch type {
            case .insuline:
                return .insulinList(userId: profileId)
            case .sugar:
                return .sugarList(userId: profileId)
            case .bloodOxygen:
                return .bloodOxygenList(userId: profileId)
            case .temperature:
                return .temperatureList(userId: profileId)
            case .heartBeat:
                return .pulseList(userId: profileId)
            case .pressure:
                /// DEBUG ??? Need Tests and Fix
                return .bloodOxygenList(userId: profileId)
            }
        }()
        
        router.request(api) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func newValueHealthParam(model: HealthParameterModel? = nil, value: Float = 0, type: HealthParamsEnum, completion: @escaping ResultCompletion<HealthParameterModel>) {
        var params: Parameters = HealthParameterModel(id: -1, value: value).encodeForRequest()
        if let md = model {
            params = md.encodeForRequest()
        }
        let api: HealthParamsApi = {
            switch type {
            case .insuline:
                return .updateInsulin(params: params)
            case .sugar:
                return .updateSugar(params: params)
            case .bloodOxygen:
                return .updateBloodOxygen(params: params)
            case .temperature:
                return .updateTemperature(params: params)
            case .heartBeat:
                return .updatePulse(params: params)
            case .pressure:
                /// DEBUG ??? Need Tests and Fix
                return .pulseList(userId: -1)
            }
        }()
        
        router.request(api) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}
