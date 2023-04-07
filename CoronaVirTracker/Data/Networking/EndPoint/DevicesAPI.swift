//
//  DevicesAPI.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 17.02.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

public enum DevicesAPI {
    case getConnectionsHistory
    case saveConnection(params: Parameters)
}

extension DevicesAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: ServerURLs.api) else { fatalError(NetworkError.baseURLNil.rawValue) }
        return url
    }
    
    var path: String {
        switch self {
        case .getConnectionsHistory, .saveConnection:
            return "bracelet"
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getConnectionsHistory: return .get
        case .saveConnection: return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getConnectionsHistory:
            return .request
        case .saveConnection(let params):
            return .requestBodyJson(bodyParameters: params)
        }
    }
    
    var headers: HTTPHeaders? {
        guard let token = KeychainUtility.getCurrentUserToken() else { return nil }
        return TypeHeaders.create(token: token)
    }
}
