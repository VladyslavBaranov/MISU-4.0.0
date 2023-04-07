//
//  MemberPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 08.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct MemberPage: View {
    
    @State var user: UserModel
    @Environment(\.presentationMode) var mode
    
    var onChatPressed: ((ChatV2) -> ())?
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 40)
            ZStack {
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("orange_back")
                            .font(.system(size: 24))
                    }
                    Spacer()
                }
                Text(Localizer.menuString(.myFamily))
                    .multilineTextAlignment(.center)
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .foregroundColor(.black)
                
            }
            .padding()
            .foregroundColor(.black)
            
            ScrollView {
                
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 50)
                    
                    buildProfileCard()
                    
                }
                
                HStack {
                    Text(locStr("Health indicators"))
                        .font(CustomFonts.createInter(weight: .bold, size: 22))
                        .foregroundColor(Color(Style.TextColors.commonText))
                    Spacer()
                }
                .padding(EdgeInsets(top: 25, leading: 16, bottom: 0, trailing: 16))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        IndicatorView(indicators: [], type: .pressure)
                        IndicatorView(indicators: [], type: .sugar)
                        IndicatorView(indicators: [], type: .heartrate)
                        IndicatorView(indicators: getTemperature(), type: .temperature)
                    }
                    .padding([.leading, .trailing], 16)
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.width * 0.4)
                
                if user.id != KeyStore.getIntValue(for: .currentUserId) {
                    
                    VStack(spacing: 15) {
                        Button {
                            if let user = ChatLocalManager.shared.getChatWithUser(id: user.id)?.getParticipant(id: user.id) {
                                if let phoneCallURL = URL(string: "tel://\(user.mobile)") {
                                    let application:UIApplication = UIApplication.shared
                                    if (application.canOpenURL(phoneCallURL)) {
                                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color(Style.TextColors.mainRed))
                                    .frame(height: 50)
                                HStack {
                                    Image("member_call")
                                    Text(Localizer.menuString(.call))
                                        .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        Button {
                            if let chat = ChatLocalManager.shared.getChatWithUser(id: user.id) {
                                onChatPressed?(chat)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .stroke(Color(Style.TextColors.mainRed), lineWidth: 1)
                                    .frame(height: 50)
                                HStack {
                                    Image("member_message")
                                    Text(Localizer.menuString(.message))
                                        .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                        .foregroundColor(Color(Style.TextColors.mainRed))
                                }
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            let id = user.id
            self.user = RealmUserModel.getBy(id: user.id)?.model() ?? .init(id: 0)
            
            VariousEndpointManager.shared.getUserByID(id) { model in
                if let model = model {
                    user = model
                    let realmUser = RealmUserModel()
                    realmUser.id = user.id
                    realmUser.userData = try? JSONEncoder().encode(model)
                    realmUser.isSync = true
                    realmUser.save()
                }
            }
        }
    }
    
    private func getTemperature() -> [RealmIndicator] {
        guard let temp = user.profile?.temperature else { return [] }
        let indicator = RealmIndicator()
        indicator.value = Double(temp)
        return [indicator]
    }
}

private extension MemberPage {
    func getUserName() -> String {
        guard let name = user.profile?.name else { return "--" }
        let splitted = name.split(separator: " ")
        return splitted.joined(separator: "\n")
    }
    
    func getHeight() -> String {
        let height = user.profile?.height ?? 0.0
        return String(Int(height))
    }
    
    func getWeight() -> String {
        let weight = user.profile?.weight ?? 0.0
        return String(Int(weight))
    }
    
    func getUsername() -> String {
        user.profile?.name ?? "--"
    }
    
    func getBirthdate() -> String {
        guard let date = user.profile?.birthdayDate else { return "--" }
        // guard let age = user.profile?.age else { return "--" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let string = formatter.string(from: date)
        
        let yearsInterval = abs(date.timeIntervalSince(Date()))
        let years = yearsInterval / (3600 * 24 * 365.25)
        
        return string + " (\(Int(years)) y.)"
    }
    
    func getGender() -> String {
        let gender = user.profile?.gender
        return gender?.localized.capitalized ?? "--"
    }
    
    func buildProfileCard() -> some View {
        ZStack {
            VStack(spacing: 15) {
                Color.clear
                    .frame(height: 50)
                Text(getUsername())
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .foregroundColor(Color(Style.TextColors.commonText))
                Text(getBirthdate())
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                    .foregroundColor(Color(Style.TextColors.gray))
                HStack {
                    VStack(alignment: .center, spacing: 10) {
                        Text(getGender())
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Text(locStr("Gender"))
                            .foregroundColor(Color(Style.TextColors.gray))
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center, spacing: 10) {
                        Text(getHeight())
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Text(locStr("Height (cm)"))
                            .foregroundColor(Color(Style.TextColors.gray))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center, spacing: 10) {
                        Text(getWeight())
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Text(locStr("Weight (kg)"))
                            .foregroundColor(Color(Style.TextColors.gray))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding([.trailing, .leading], 16)
                .font(CustomFonts.createInter(weight: .regular, size: 16))
                Color.clear
                    .frame(height: 20)
            }
            
            VStack {
                AvatarView(user: user)
                    .offset(x: 0, y: -45)
            
                Spacer()
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 32)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .circular)
                .stroke(Color(Style.Stroke.lightGray), lineWidth: 1 )
                .background(Color.white.cornerRadius(14))
        )
        .padding()
    }
}


final class MemberHostingController: UIHostingController<MemberPage> {
    override init(rootView: MemberPage) {
        super.init(rootView: rootView)
        view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
        self.rootView.onChatPressed = { [weak self] chat in
            let controller = UIHostingController(rootView: ChatPage(chat))
            controller.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func createInstance(_ user: UserModel) -> MemberHostingController {
        let vc = MemberHostingController(rootView: .init(user: user))
        return vc
    }
    
}
