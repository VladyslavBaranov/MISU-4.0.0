//
//  AuthManager.swift
//  WishHook
//
//  Created by Dmitriy Kruglov on 9/16/19.
//  Copyright © 2019 WHAR. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let misuDidLogOut = "misu.didlogout"
}

struct AuthManager: BaseManagerHandler {
    private let router = Router<AuthApi>()
    
    static let shared = AuthManager()
    
    private init() {}
    
    func checkUser(_ cred: CheckUserModel, completion: @escaping ResultCompletion<CheckUserModel>) {
        router.request(.checkUser(username: cred.getParamForRequest())) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func logIn(_ cred: AuthenticationModel, completion: @escaping ResultCompletion<String>) {
        print("FB LI \(cred.getParamForLoginRequest())")
        router.request(.login(userCred: cred.getParamForLoginRequest())) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func registration(authModel: AuthenticationModel, completion: @escaping ResultCompletion<String>) {
        let parameters = authModel.getParamForRegistrationRequest()
        let route: AuthApi = authModel.isNumber ? .registerNumber(userInfo: parameters) : .registerEmail(userInfo: parameters)
        router.request(route) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func logout(token: String, completion: @escaping Success200Completion) {
        router.request(.logout(token: token)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, success200Completion: completion)
        }
    }
    
    
    // MARK PROPOSED METHODS:
    func logout(_ completion: @escaping Success200Completion) {
        // gets current token
        guard let currentToken = KeychainUtility.getCurrentUserToken() else {
            completion(false, nil)
            return
        }
        
        router.request(.logout(token: currentToken)) { data, response, error in
            handleResponse(data: data, response: response, error: error, success200Completion: completion)
        }
    }
    
}
