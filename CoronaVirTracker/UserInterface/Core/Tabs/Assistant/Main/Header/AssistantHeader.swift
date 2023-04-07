//
//  AssistantHeader.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 29.06.2022.
//

import SwiftUI

struct AsistanceHeaderShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: .init(width: 20, height: 20)
        )
        return Path(path.cgPath)
    }
}

struct AssistantHeader: View {
    
    @State var unreadCount = RealmMessage.getUnreadMessagesCount()
    
    @Binding var scaledownFactor: CGFloat
    @Binding var verticalOffset: CGFloat
    
    @State var fullGroupOpacity = 1.0
    
    var onChatIconTapped: (() -> ())?
    var onNotificationsTapped: (() -> ())?
    
    var body: some View {
        ZStack {
            if scaledownFactor < 0.4 {
                VStack(alignment: .center, spacing: 16) {
                    Color.clear
                        .frame(height: 50)
                    Spacer()
                    Group {
                        Group {
                            Text(getTopStr())
                                .font(CustomFonts.createInter(weight: .bold, size: 22))
                                .foregroundColor(.white)
                            Text(getBottomStr())
                                .font(CustomFonts.createInter(weight: .regular, size: 16))
                                .lineLimit(2)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .scaleEffect(1 - scaledownFactor)
                        .opacity(1 - scaledownFactor)
                        
                        Color.clear
                            .frame(height: 5)
                        
                        VStack(spacing: 20) {
                            Button {
                                call()
                            } label: {
                                HStack {
                                    Image("Phone")
                                        .font(.system(size: 24))
                                    Text(locStr("mah_str_3"))
                                        .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                        .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.97))
                                }
                                .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                                .background(
                                    Capsule(style: .circular)
                                        .fill(Color.white)
                                )
                            }
                            Button {
                                onChatIconTapped?()
                            } label: {
                                HStack {
                                    Image("message_icon")
                                        .font(.system(size: 24))
                                    Text(locStr("mah_str_4"))
                                        .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                        .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.97))
                                }
                                .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                                .background(
                                    Capsule(style: .circular)
                                        .fill(Color.white)
                                )
                            }
                        }
                    }
                    .opacity(calculateFullGroupOpacity())
                    Spacer(minLength: 20)
                }
                
            } else {
                HStack {
                    Button {
                        call()
                    } label: {
                        HStack {
                            Image("Phone")
                                .font(.system(size: 22))
                            Text(locStr("mah_str_3"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.97))
                        }
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 45)
                        .background(
                            Capsule(style: .circular)
                                .fill(Color.white)
                        )
                    }
                    Button {
                        onChatIconTapped?()
                    } label: {
                        HStack {
                            Image("message_icon")
                                .font(.system(size: 22))
                            Text(locStr("mah_str_4"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.97))
                        }
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 45)
                        .background(
                            Capsule(style: .circular)
                                .fill(Color.white)
                        )
                    }
                }
                .opacity(calculateCompactGroupOpacity())
                .offset(x: 0, y: 30)
            }
            
            VStack {
                Color.clear
                    .frame(height: 30)
                ZStack {
                }
                .padding()
                .foregroundColor(.white)
                Spacer()
            }
            
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.38, green: 0.65, blue: 1),
                    Color(red: 0.31, green: 0.49, blue: 0.95)
                ],
                startPoint: .init(x: 0.5, y: 0),
                endPoint: .init(x: 0.5, y: 1)
            )
        )
        .clipShape(AsistanceHeaderShape())
        .frame(height: calculateHeight())
        .navigationBarHidden(true)
        .onReceive(
            NotificationCenter.default.publisher(for: NotificationManager.shared.notificationName(for: .didUpdateChats))
        ) { _ in
            DispatchQueue.main.async {
                unreadCount = RealmMessage.getUnreadMessagesCount()
            }
        }
    }
    
    func calculateCompactGroupOpacity() -> CGFloat {
        let linearAlphaFactor = scaledownFactor - 0.4
        // print("L \(linearAlphaFactor)")
        return 3.6 * linearAlphaFactor * linearAlphaFactor
    }
    
    func calculateFullGroupOpacity() -> CGFloat {
        let linearAlphaFactor = 1 - scaledownFactor
        // print("L \(linearAlphaFactor)")
        return -6 * pow((linearAlphaFactor - 1), 2.0) + 1
    }
    
    func calculateHeight() -> CGFloat {
        let targetH = UIScreen.main.bounds.width * 0.95 + verticalOffset
        let minH = UIScreen.main.bounds.width * 0.5
        
        if targetH > minH {
            return UIScreen.main.bounds.width * 0.95 + verticalOffset
        }
        return minH
    }
    
    func call() {
        
        if let country = KeyStore.getStringValue(for: .userCountry) {
            
            if country == "pl" {
                
                let mobile = "+48536536983"
                if let phoneCallURL = URL(string: "tel://\(mobile)") {
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }
                }
                
            } else if country == "ua" {
                guard let assistantData = RealmJSON.retreive(for: .assistant) else { return }
                guard let assistant = try? JSONDecoder().decode(Assistant.self, from: assistantData) else { return }
                
                var mobile: String = assistant.mobile
                
                if let phoneCallURL = URL(string: "tel://\(mobile)") {
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                    }
                } else {
                }
            }
        }
        
        
    }
    
    private func getTopStr() -> String {
        guard let country = KeyStore.getStringValue(for: .userCountry) else {
            return locStr("mah_str_1")
        }
        if country == "pl" {
            return locStr("mah_pol_str_1")
        }
        return locStr("mah_str_1")
    }
    
    private func getBottomStr() -> String {
        guard let country = KeyStore.getStringValue(for: .userCountry) else {
            return locStr("mah_str_2")
        }
        if country == "pl" {
            return locStr("mah_pol_str_2")
        }
        return locStr("mah_str_2")
    }
}
