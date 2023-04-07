//
//  HeaderEncoder.swift
//  WishHook
//
//  Created by Dmitriy Kruglov on 9/6/19.
//  Copyright © 2019 WHAR. All rights reserved.
//

import Foundation

public struct HeaderEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingJsonFailed
        }
    }
}
