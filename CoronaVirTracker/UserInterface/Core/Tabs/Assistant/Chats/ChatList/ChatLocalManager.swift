//
//  ChatLocalManager.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 28.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation
 
protocol ChatLocalManagerDelegate: AnyObject {
    func willStartLoadingChatList(_ manager: ChatLocalManager)
    func didLoadChatList(_ manager: ChatLocalManager)
}

final class ChatLocalManager {
    
    private var timer: Timer!
    
    private(set) var chats: [ChatV2] = []
    
    static let shared = ChatLocalManager()
    
    weak var delegate: ChatLocalManagerDelegate!
    
    private init() {}
    
    func startObserving() {
        loadChats()
        // timer = Timer.scheduledTimer(
        //   timeInterval: 30,
        //    target: self, selector: #selector(loadChats), userInfo: nil, repeats: true)
        // timer.fire()
    }
    
    func endObserving() {
        timer.invalidate()
    }
    
    func getChatWithUser(id: Int) -> ChatV2? {
        chats.first { chat in
            chat.participants.contains { p in
                p.id == id
            }
        }
    }
}

private extension ChatLocalManager {
    @objc func loadChats() {
        
        if let data = RealmJSON.retreive(for: .chatList) {
            if let chats = try? JSONDecoder().decode([ChatV2].self, from: data) {
                self.chats = chats
                delegate?.didLoadChatList(self)
            }
        }
        
        delegate?.willStartLoadingChatList(self)
        ChatManager.shared.getAllChats { [weak self] result, error in
            if let result = result {
                if let data = try? JSONEncoder().encode(result) {
                    RealmJSON.write(data, for: .chatList)
                }
                self?.chats = result.createThreadsWithoutDuplicates()
                if let sSelf = self {
                    self?.delegate?.didLoadChatList(sSelf)
                }
                self?.updateChats()
            }
        }
    }
    
    func updateChats() {
        for chat in chats {
            ChatManager.shared.getChat(chatId: chat.id) { result, error in
                if let result = result {
                    RealmMessage.saveChat(from: result.messages, chat: chat)
                    NotificationManager.shared.post(.didUpdateChats)
                }
            }
        }
    }
}
