//
//  _MenuUserSettingsAPIPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 29.01.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct _MenuUserSettingsAPIPage: View {
    
    let requests: [String] = [
        "https://misu.pp.ua/api/current_user?last_indicators=true",
        "https://misu.pp.ua/api/user/country",
        "https://misu.pp.ua/api/profile?page=1",
        "https://misu.pp.ua/api/group",
        "https://misu.pp.ua/api/request",
        "https://misu.pp.ua/api/notification",
        "https://misu.pp.ua/assistance/insurance/",
        "https://misu.pp.ua/assistance/assistance",
        "https://misu.pp.ua/assistance/status",
        "https://misu.pp.ua/assistance/info/"
    ]
    
    @State private var pickedOption = 0
    
    @State var isError = false
    @State var editorText = "Hello"
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Picker("", selection: $pickedOption) {
                        ForEach(0..<requests.count, id: \.self) { index in
                            Text(requests[index]).tag(index)
                        }
                    }
                    
                }
                .padding([.top, .bottom], 16)
            }
            Button {
                makeRequest()
            } label: {
                Text("Request")
            }

            TextEditor(text: $editorText)
                .font(.system(size: 17, weight: .medium, design: .monospaced))
                .foregroundColor(isError ? .red : .black)
            
        }
        .padding([.leading, .trailing], 16)
    }
    
    private func makeRequest() {
        guard let url = URL(string: requests[pickedOption]) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = KeychainUtility.getCurrentUserToken() {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(
            with: request
        ) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    isError = true
                    editorText = error.localizedDescription
                }
            }
            if let data = data {
                if let string = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        isError = false
                        editorText = string
                    }
                } else {
                    DispatchQueue.main.async {
                        isError = false
                        editorText = "nil"
                    }
                }
            }
        }
        task.resume()
    }
}

final class _MenuUserSettingsAPIController: UIHostingController<_MenuUserSettingsAPIPage> {
    static func createInstance() -> UIViewController {
        let vc = _MenuUserSettingsAPIController(rootView: .init())
        return vc
    }
}
