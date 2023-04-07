//
//  ChatAdditionalModels.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 24.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

struct ChatParticipant: Codable, Equatable {
    var id: Int
    var username: String
    var mobile: String
    var profile_name: String?
    var image: String?
    
    static func == (_ lhs: ChatParticipant, _ rhs: ChatParticipant) -> Bool {
        lhs.id == rhs.id
    }
}

struct ChatMessage: Codable {
    
    struct Request: Codable {
        var id: Int
        var group: Int
        var status: Bool
    }
    
    var id: Int
    var text: String
    var sender: Int
    var datetime: String
    var recommendation: Bool
    var image: String?
    var file: String?
    var request: Request?
    var ordered: Bool
    
    func getDate() -> Date {
        let dateTimeString = datetime
        var finalString = ""
        var shouldOmit = false
        for char in dateTimeString {
            if char == "." {
                shouldOmit = true
            } else if char == "Z" {
                shouldOmit = false
            }
            if !shouldOmit {
                finalString.append(char)
            }
        }
        
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: finalString) ?? Date()
    }
}

struct ChatV2: Codable {
    var id: Int
    var participants: [ChatParticipant]
    var last_message: String?
    var messages: [Message]
    var unread: Int
    
    func getParticipant(id: Int) -> ChatParticipant? {
        participants.first { p in
            p.id == id
        }
    }
}

/*
struct ChatModelV2: Codable {
    var threads: [ChatV2]
    
    var thread_id: Int
    var thread_messages: [Message]
    var partner: ChatParticipant
}
*/

struct ChatListModel: Codable {
    var threads: [ChatV2]
    
    func createThreadsWithoutDuplicates() -> [ChatV2] {
        var result: [ChatV2] = []
        for thread in threads {
            if !result.contains(where: { $0.participants == thread.participants }) {
                result.append(thread)
            }
        }
        return result
    }
}
