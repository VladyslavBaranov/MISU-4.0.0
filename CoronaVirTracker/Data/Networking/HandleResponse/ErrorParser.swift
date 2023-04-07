//
//  ErrorParser.swift
//  WishHook
//
//  Created by Dmitriy Kruglov on 12/3/19.
//  Copyright © 2019 WHAR. All rights reserved.
//

import Foundation

func ErrorParser(response: HTTPURLResponse, data: Data) {
    print("-----DebugParser-----")
    print("status: \(response.statusCode)")
    print("url: \(response.url?.absoluteString ?? "nil")")
//    print("headers: \(response.allHeaderFields)")
    
    print(String(data: data, encoding: .utf8) ?? "Data empty ...")
    do {
        let response = try JSONDecoder().decode(Dictionary<String, String>.self, from: data)
        print("Resp err StrStr: \(response)")
    } catch {
        
    }
    do {
        let response = try JSONDecoder().decode(Dictionary<String, Dictionary<String,[String]>>.self, from: data)
        print("Resp err StrStrStr: \(response)")
    } catch {
        
    }
    
    print("-----END-----")
}
