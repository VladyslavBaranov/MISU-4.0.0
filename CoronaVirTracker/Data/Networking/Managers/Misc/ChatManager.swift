//
//  ChatManager.swift
//  CoronaVirTracker
//
//  Created by WH ak on 01.07.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import Foundation

struct ChatManager: BaseManagerHandler {
    private let router = Router<ChatAPI>()
    static let shared = ChatManager()
    private init() {}
    
    func unreadedChatsCount(completion: @escaping ResultCompletion<UnreadedChats>) {
        router.request(.unreadedChatsCount) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func readChat(id: Int, completion: @escaping Success200Completion) {
        router.request(.readMessagesIn(cId: id)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, success200Completion: completion)
        }
    }
    
    func send(message: SendMessage, chatId: Int, completion: @escaping ResultCompletion<Message>) {
        let dataToSend = message.encodeToParameters()
        router.request(.sendMessage(chatId: chatId, param: dataToSend.params, files: dataToSend.files)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getMessageIdsListOf(chatId: Int, completion: @escaping ResultCompletion<[Message]>) {
        router.request(.getMessagesIdsList(chatId: chatId)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getMessageBy(id: Int, completion: @escaping ResultCompletion<[Message]>) -> URLSessionTask? {
        return router.requestWithReturn(.getMessageBy(id: id)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    @available(*, deprecated, message: "This method is redundant in chats API")
    func getChatIdsList(completion: @escaping ResultCompletion<[Chat]>) {
        router.request(.getChatsIdsList) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getChatBy(id: Int, completion: @escaping ResultCompletion<[Chat]>) -> URLSessionTask? {
        return router.requestWithReturn(.getChatBy(id: id)) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func allPaginated(chatModel: ChatsThreadsPM, completion: @escaping ResultCompletion<ChatsThreadsPM>) {
        router.request(.allPaginated(params: chatModel.nextPageURLParams())) { data, response, error in
            handleResponse(data: data, response: response, error: error, successHandleCompletion: debugSuccessHandleCompletion(), failureCompletion: debugFailureHandleCompletion, completion: completion)
        }
    }
    
    func create(token: String, createModel: CreateChat, completion: @escaping ResultCompletion<Chat>) {
        router.request(.createChat(token: token, param: createModel.encodeToParameters())) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    @available(*, deprecated, message: "Use getAllChats(_:) instead")
    func getAllChats(token: String, completion: @escaping ResultCompletion<[ChatModel]>) {
        router.request(.getAllChats(token: token)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getChat(chatId: Int, completion: @escaping ResultCompletion<ChatModel>) {
        router.request(.getChat(chatId: chatId)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}

extension ChatManager {
    func getAllChats(completion: @escaping ResultCompletion<ChatListModel>) {
        guard let token = KeychainUtility.getCurrentUserToken() else { return }
        router.request(.getAllChats(token: token)) {
            data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}
