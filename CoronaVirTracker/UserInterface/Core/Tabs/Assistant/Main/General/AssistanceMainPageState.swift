//
//  AssistanceMainPageState.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Combine
import Foundation

final class AssistanceMainPageState: ObservableObject {
    
    init() {
        fetchAssistant()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(didChangeUserCountry),
            name: NotificationManager.shared.notificationName(for: .didChangeUserCountry), object: nil)
    }
    
    private func fetchAssistant() {
        AssistantManager.shared.getAssistant { result, error in
            if let assistant = result {
                if let data = try? JSONEncoder().encode(assistant) {
                    DispatchQueue.main.async {
                        RealmJSON.write(data, for: .assistant)
                    }
                }
            }
        }
    }
    
    @objc func didChangeUserCountry() {
        objectWillChange.send()
    }
}
