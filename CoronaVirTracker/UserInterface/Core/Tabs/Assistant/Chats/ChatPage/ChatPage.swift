//
//  ChatPage.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 02.07.2022.
//

import SwiftUI

class ChatPageState: ObservableObject {
    
    @Published var chat: ChatV2!
    
    @Published var messages: [RealmMessage] = []
    
    init(_ chat: ChatV2!) {
        self.chat = chat
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadChat),
            name: NotificationManager.shared.notificationName(for: .didUpdateChats), object: nil)
    }
    
    func getPhoneNumber() -> String {
        chat.participants.first?.mobile ?? ""
    }
    
    func getChatName() -> String {
        if let profile_name = chat.participants.first?.profile_name {
            var splitted = profile_name.split(separator: " ")
            splitted.removeAll { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            return splitted.joined(separator: " ")
        }
        return "--"
    }
    
    @objc func loadChat() {
        DispatchQueue.main.async { [weak self] in
            if let sSelf = self {
                sSelf.messages = RealmMessage.getMessages(for: sSelf.chat).sorted(by: { $0.date < $1.date })
            }
        }
        RealmMessage.setAllWasSeen(in: chat)
    }
    
    func remove(at index: Int) {
        let message = messages.remove(at: index)
        RealmMessage.delete(message)
    }
    
    func sendMessage(_ message: RealmMessage) {
        let model = SendMessage(sender: KeyStore.getIntValue(for: .currentUserId), message: message.string)
        ChatManager.shared.send(message: model, chatId: chat.id) { result, error in
            if error == nil {
                DispatchQueue.main.async {
                    message.setIsSync()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct ChatPage: View {
    
    @ObservedObject var state = ChatPageState(nil)
    
    init(_ chat: ChatV2) {
        state.chat = chat
        state.loadChat()
        scrollTarget = state.messages.count - 1
        RealmMessage.setAllWasSeen(in: chat)
    }
    
    @State var scrollTarget: Int = 0
    
    @State var tfHeight: CGFloat = CustomFonts.createUIInter(weight: .regular, size: 18).lineHeight + 20
    
    @State var messageText: String = ""
    
    @State var micButtonOpacity: CGFloat = 1.0
    
    @State var isFirstResponder = false
    
    @State var textFieldTrailingPadding: CGFloat = 0.0
    
    @State var fakeDimOpacity = 1.0
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack(spacing: 0) {
            Color.white
                .frame(height: 30)
            ZStack {
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("orange_back")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    Button {
                        if let phoneCallURL = URL(string: "tel://\(state.getPhoneNumber())") {
                            let application:UIApplication = UIApplication.shared
                            if (application.canOpenURL(phoneCallURL)) {
                                application.open(phoneCallURL, options: [:], completionHandler: nil)
                            }
                        }
                    } label: {
                        Image("BlackPhone")
                    }
                }
                Text(state.getChatName())
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            Color(red: 0.89, green: 0.94, blue: 1)
                .frame(height: 0.5)
            
            ZStack {
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack {
                            
                            ForEach(0..<state.messages.count, id: \.self) { index in
                                ChatMessageContainerView(
                                    message: state.messages[index]
                                ) {
                                    withAnimation {
                                        state.remove(at: index)
                                    }
                                    scrollTarget = state.messages.count - 1
                                } onResend: {
                                    state.sendMessage(state.messages[index])
                                }
                                .id(index)
                            }
                            
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                withAnimation {
                                    fakeDimOpacity = 0
                                }
                                proxy.scrollTo(state.messages.count - 1)
                            }
                        }
                    }
                }.onTapGesture {
                    UIApplication.shared.endEditing()
                }
                Group {
                    Color.white
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .opacity(fakeDimOpacity)
            }
            
            VStack(spacing: 0) {
                Color(red: 0.89, green: 0.94, blue: 1)
                    .frame(height: 0.5)
                ZStack {
                    HStack(alignment: .center) {
                        ZStack {
                            Button {
                            } label: {
                                Image("Pin")
                            }
                        }.frame(width: 30, height: 30)
                        
                        Spacer()
                        
                        Button {
                            
                            guard !messageText.isEmpty else { return }
                            
                            let message = RealmMessage()
                            message.chatId = state.chat.id
                            message.string = messageText
                            message.date = Date()
                            message.isSync = false
                            message.wasSeen = true
                            message.senderId = KeyStore.getIntValue(for: .currentUserId)
                            
                            RealmMessage.save(message)
                            
                            withAnimation {
                                state.messages.append(message)
                            }
                            
                            scrollTarget = state.messages.count - 1
                            
                            messageText = ""
                            
                            state.sendMessage(message)
                            
                        } label: {
                            Image("SendMSG")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .opacity(1)
                        .scaleEffect(micButtonOpacity == 0 ? 1 : 0.05)
                        
                    }
                    MultilineTextField(text: $messageText) { lines, lineH in
                        withAnimation(.linear(duration: 0.3)) {
                            textFieldTrailingPadding = messageText.isEmpty ? 0 : 50
                            micButtonOpacity = messageText.isEmpty ? 1 : 0
                        }
                        if lines <= 10 {
                            tfHeight = CGFloat(lines) * lineH + 20
                        }
                    }
                    .frame(height: tfHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color(white: 0.9), lineWidth: 0.7)
                    )
                    .padding(.leading, 40)
                    .padding(.trailing, textFieldTrailingPadding)
                }
                .padding(EdgeInsets(top: 10, leading: 12, bottom: 12, trailing: 10))
                .background(Color.white)
                .foregroundColor(.black)
            }
        }
        .ignoresSafeArea(.all, edges: [.top])
        .background(Color(red: 0.98, green: 0.98, blue: 1))
        .navigationBarHidden(true)
    }
}
