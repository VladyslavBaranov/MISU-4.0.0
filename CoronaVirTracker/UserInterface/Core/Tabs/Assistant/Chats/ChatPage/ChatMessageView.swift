//
//  ChatMessageView.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 09.07.2022.
//

import SwiftUI

enum MessageOrigin: Int, Codable {
    case current, other
}

struct MessageShape: Shape {
    
    let origin: MessageOrigin
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: origin == .current ? [.topLeft, .bottomRight, .bottomLeft] : [.topRight, .bottomRight, .bottomLeft],
            cornerRadii: .init(width: 12, height: 12)
        )
         return Path(path.cgPath)
    }
}
 
struct ChatMessageView: View {
    
    let origin: MessageOrigin
    let message: RealmMessage
    
    var onDelete: (() -> ())?
    var onResend: (() -> ())?
    
    var body: some View {
        HStack {
            if origin == .other {
                VStack {
                    Image("DoctorPhoto")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Spacer()
                }
            }
            VStack {
                ZStack {
                    VStack(alignment: .leading) {
                        Text(message.string)
                            .font(CustomFonts.createInter(weight: .regular, size: 17))
                            .multilineTextAlignment(.leading)
                        if !message.isSync {
                            HStack {
                                Spacer()
                                Menu {
                                    Button(action: {
                                        onResend?()
                                    }) {
                                        Label("Послати заново", systemImage: "arrow.clockwise")
                                    }
                                    
                                    if #available(iOS 15.0, *) {
                                        Button(role: .destructive, action: {
                                            onDelete?()
                                        }) {
                                            Label("Видалити", systemImage: "trash")
                                                .foregroundColor(.red)
                                        }
                                    } else {
                                        Button {
                                            onDelete?()
                                        } label: {
                                            Label("Видалити", systemImage: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    
                                    
                                } label: {
                                    Image("warningIcon")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        HStack {
                            Spacer()
                            Text(message.getTimeString())
                                .foregroundColor(.gray)
                                .font(CustomFonts.createInter(weight: .regular, size: 12))
                        }
                    }
                    .padding(12)
                }
                .frame(minWidth: 50, maxWidth: UIScreen.main.bounds.width * 0.7)
                .background(
                    origin == .current ? Color(red: 0.86, green: 0.91, blue: 1) :
                        Color(red: 0.95, green: 0.97, blue: 1)
                )
                .overlay(MessageShape(origin: origin).stroke(Color(Style.Stroke.solid), lineWidth: 1))
                .clipShape(MessageShape(origin: origin))
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = message.string
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
            }
        }.padding(16)
    }
}

struct ChatMessageContainerView: View {
    
    let message: RealmMessage
    let onDelete: (() -> ())
    let onResend: (() -> ())
    
    var body: some View {
        HStack {
            if getOrigin() == .current {
                Spacer()
            }
            ChatMessageView(origin: getOrigin(), message: message) {
                onDelete()
            } onResend: {
                onResend()
            }
            if getOrigin() == .other {
                Spacer()
            }
        }
    }
    
    func getOrigin() -> MessageOrigin {
        let isMe = message.senderId == KeyStore.getIntValue(for: .currentUserId)
        return isMe ? .current : .other
    }
}
