//
//  AssistantManager.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 14.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

struct Assistant: Codable {
    var mobile: String
    var chat_id: Int
}

struct AssistanceStatus: Codable {
    var activate: Bool
    var need_info: String?
    var available: Bool
}

public enum AssistantAPI {
    case assistant
    case status
}

extension AssistantAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: ServerURLs.assistance) else { fatalError(NetworkError.baseURLNil.rawValue) }
        return url
    }
    
    var path: String {
        switch self {
        case .assistant:
            return "assistance"
        case .status:
            return "status"
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .assistant, .status:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .assistant, .status:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        guard let token = KeychainUtility.getCurrentUserToken() else { return nil }
        return TypeHeaders.create(token: token)
    }
}

struct AssistantManager: BaseManagerHandler {
    
    static let shared = AssistantManager()
    
    private let router = Router<AssistantAPI>()
    
    private init() {}
    
    func getAssistant(_ completion: @escaping ResultCompletion<Assistant>) {
        router.request(.assistant) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getInsuranceStatus(_ completion: @escaping ResultCompletion<AssistanceStatus>) {
        router.request(.status) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}
