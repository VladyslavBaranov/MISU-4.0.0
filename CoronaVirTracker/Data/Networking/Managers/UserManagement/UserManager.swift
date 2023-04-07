//
//  UserManager.swift
//  CoronaVirTracker
//
//  Created by Dmitriy Kruglov on 4/1/20.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation
import WatchVPN

struct UserManager: BaseManagerHandler {
    private let router = Router<UserApi>()
    
    static let shared = UserManager()
    
    private init() {}
    
    func currentUserToken() -> String? {
        KeychainUtility.getCurrentUserToken()
    }
    
    func delete(_ completion: @escaping Success200Completion) {
        router.request(.delete) { data, response, error in
            handleResponse(data: data, response: response, error: error, success200Completion: completion)
        }
    }
    
    func getCurrent(_ token: String, completion: @escaping ResultCompletion<UserModel>) {
        router.request(.getCurrentUser(token: token)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
//            handleResponse(data: data, response: response, error: error, successHandleCompletion: debugSuccessHandleCompletion(), failureCompletion: debugFailureHandleCompletion, completion: completion)
        }
    }
        
    func createProfile(profile: UserCardModel, completion: @escaping ResultCompletion<UserCardModel>) {
        router.request(.createProfile(profile: profile.encodeForCreateRequest())) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
//            handleResponse(data: data, response: response, error: error, successHandleCompletion: debugSuccessHandleCompletion(), failureCompletion: debugFailureHandleCompletion, completion: completion)
        }
    }
    
    func updateUser(_ token: String, params: Parameters, files: Files, completion: @escaping ResultCompletion<UserCardModel>) {
        router.request(.updateProfile(token: token, updatedProfile: params, updatedFiles: files)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func createDoctor(_ token: String, doctor: DoctorModel, completion: @escaping ResultCompletion<DoctorModel>) {
        router.request(.createDoctor(token: token, profile: doctor.encodeForCreateRequest())) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func updateDoctor(_ token: String, params: Parameters, files: Files, completion: @escaping ResultCompletion<DoctorModel>) {
        router.request(.updateDoctor(token: token, updatedDoctor: params, updatedFiles: files)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func updateIll(params: Parameters, completion: @escaping ResultCompletion<HealthStatisticModel>) {
        router.request(.updateIll(updatedIll: params)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func create(newLocation: LocationModel, completion: @escaping ResultCompletion<LocationModel>) {
        guard let token = KeychainUtility.getCurrentUserToken() else { return }
        router.request(.createLocation(token: token, location: newLocation.getParamsToCreate())) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getHealthParamsHistory(type: SugarInsulineEnum, profileId: Int? = nil, completion: @escaping ResultCompletion<[HealthParameterModel]>) {
        let param: UserApi = type == .sugar ? .sugarList(userId: profileId) : .insulinList(userId: profileId)
        
        router.request(param) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func newValueHealthParam(model: HealthParameterModel? = nil, value: Float = 0, type: SugarInsulineEnum, completion: @escaping ResultCompletion<HealthParameterModel>) {
        var params: Parameters = HealthParameterModel(id: -1, value: value).encodeForRequest()
        if let md = model {
            params = md.encodeForRequest()
        }
        let api: UserApi = type == .sugar ? .updateSugar(params: params) : .updateInsulin(params: params)
        
        router.request(api) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}

extension UserManager {
    
    func getCurrentWithRealm(_ completion: @escaping ResultCompletion<UserModel>) {
        if let current = RealmUserModel.getCurrent() {
            if let data = current.userData {
                if let user = try? JSONDecoder().decode(UserModel.self, from: data) {
                    completion(user, nil)
                }
            }
        }
        if let token = KeychainUtility.getCurrentUserToken() {
            UserManager.shared.getCurrent(token) { result, error in
                if let res = result {
                    KeyStore.saveValue(res.id, for: .currentUserId)
                    let realmModel = RealmUserModel()
                    realmModel.id = res.id
                    realmModel.userData = try? JSONEncoder().encode(res)
                    realmModel.isSync = true
                    realmModel.save()
                }
                DispatchQueue.main.async {
                    completion(result, error)
                }
            }
        }
    }
    
    func updateUserWithRealmIfNeeded() {
        if let token = KeychainUtility.getCurrentUserToken() {
            if let currentUser = RealmUserModel.getCurrent() {
                if !currentUser.isSync {
                    if let profile = currentUser.model()?.profile {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        updateUser(
                            token,
                            params: [
                                "name": profile.name ?? "--",
                                "birth_date": formatter.string(from: profile.birthdayDate ?? Date()),
                                "gender": profile.gender.rawValue,
                                "height": Int(profile.height ?? 0),
                                "weight": Int(profile.weight ?? 0)
                            ],
                            files: [.init(name: "IMG-\(UUID().uuidString).jpg", type: .imageJpg, data: profile.image?.jpegData(compressionQuality: 1))])
                        { result, error in
                            if error == nil {
                                DispatchQueue.main.async {
                                    currentUser.ensureSync()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
