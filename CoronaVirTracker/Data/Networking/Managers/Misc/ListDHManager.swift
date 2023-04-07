//
//  ListDHManager.swift
//  CoronaVirTracker
//
//  Created by WH ak on 26.06.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation

struct ListDHManager: BaseManagerHandler {
    private let router = Router<ListDHApi>()
    static let shared = ListDHManager()
    private init() {}
    
    func getAllHospitals(onlyOneHOspital hosp: HospitalModel? = nil, one: Bool, completion: @escaping ResultCompletion<[HospitalModel]>) {
        if one, hosp?.id == nil {
            completion(nil, nil)
            return
        }
        router.request(.getAllHospitals(id: hosp?.id)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getAllDoctors(onlyOneDoctor doctor: UserModel? = nil, one: Bool, completion: @escaping ResultCompletion<[UserModel]>) {
        if one, doctor?.doctor?.id == nil {
            completion(nil, nil)
            return
        }
        router.request(.getAllDoctors(id: doctor?.doctor?.id)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getGetPatientsOfCurrentDoctor(token: String, completion: @escaping ResultCompletion<[UserModel]>) {
        router.request(.getGetPatientsOfCurrentDoctor(token: token)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getProfile(id: Int, completion: @escaping ResultCompletion<[UserModel]>) -> URLSessionTask? {
        return router.requestWithReturn(.getPatient(id: id)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}

