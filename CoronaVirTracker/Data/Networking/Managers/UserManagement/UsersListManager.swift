//
//  UsersListManager.swift
//  CoronaVirTracker
//
//  Created by Dmitriy Kruglov on 4/1/20.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation

struct UsersListManager: BaseManagerHandler {
    private let router = Router<UsersListApi>()
    
    static let shared = UsersListManager()
    
    private init() {}
    
    func getAllUsersReturn(id: Int? = nil, one: Bool, completion: @escaping ResultCompletion<[UserModel]>) -> URLSessionTask? {
        if id == nil && one {
            completion(nil, nil)
            return nil
        }
        return router.requestWithReturn(.getAllUsers(id: id)) {
            data, response, error in
                handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getAllUsers(id: Int? = nil, one: Bool, completion: @escaping ResultCompletion<[UserModel]>) {
        if id == nil && one { completion(nil, nil) }
        router.request(.getAllUsers(id: id)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}

