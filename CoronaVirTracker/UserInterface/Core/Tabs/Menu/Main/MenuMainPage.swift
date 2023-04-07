//
//  MenuMainPage.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 11.07.2022.
//

import SwiftUI
import RealmSwift

struct MenuMainPage: View {
    
    @ObservedObject var pageState = MenuMainPageState()
    
    @State var partnersShown = false
    
    var onUserTapped: ((UserModel) -> ())?
    var onSettingsTapped: ((RealmUserModel?) -> ())?
	var onFamilyGroupTapped: ((Bool) -> ())?
    var onShowAddNewMember: (() -> ())?
    var onLongPress: ((UserModel) -> ())?
    var onOpenSubscriptions: (() -> ())?
    
    var onOpenReport: (() -> ())?
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 40)
            ZStack {
                HStack {
                    if pageState.failedToLoadDate {
                        Image("warningIcon")
                            .resizable()
                            .frame(width: 22, height: 22)
                    }
                    if pageState.isUpdating && !pageState.failedToLoadDate {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    /*
                    Button {
                        onOpenReport?()
                    } label: {
                        Text("Report")
                    }
                     */
                    Spacer()
                    Button {
                        onSettingsTapped?(pageState.realmUserModel)
                    } label: {
                        Image("settings_icon")
                    }
                }
                Text(getUserName())
                    .multilineTextAlignment(.center)
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .foregroundColor(.black)
               
            }
            .padding()
            .foregroundColor(.black)

            ScrollView {

                NavigationLink(isActive: $partnersShown) {
                    MenuAlphaInsurancePage()
                } label: {
                    EmptyView()
                }
                
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 50)
                    
                    buildProfileCard()
                    
                    if pageState.currentUser != nil {
                        
                        /*
                        if KeyStore.getStringValue(for: .subscriptionID) == nil {
                            
                            HStack(spacing: 5) {
                                Text("Сімʼя")
                                    .font(CustomFonts.createInter(weight: .bold, size: 18))
                                    .foregroundColor(Color(Style.TextColors.commonText))
                                Spacer()
                                HStack {
                                    Text(locStr("More"))
                                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(Color(Style.TextColors.gray))
                                
                            }
                            .padding([.leading, .trailing], 16)
                            
                            MenuMainSubscriptionView {
                                onOpenSubscriptions?()
                            }
                            
                        } else {
                            */
                            MenuMyFamilyView(showsMore: true) {
                                onFamilyGroupTapped?(pageState.isAdmin)
                            } userTapped: { user in
                                onUserTapped?(user)
                            } onNewTapped: {
                                onShowAddNewMember?()
                            } onLongPress: { user in
                                onLongPress?(user)
                            }
                        // }
					}
                    
                    Color.clear
                        .frame(height: 10)
                }
                .background(Color(red: 0.98, green: 0.98, blue: 1))
                
                VStack(spacing: 0) {
                
                    MenuPartnersView(onLookTapped: {
                        partnersShown = true
                    })
                    
                    Color(red: 0.98, green: 0.98, blue: 1)
                        .frame(height: 50)
                }
                .background(Color(red: 0.98, green: 0.98, blue: 1))
                
            }
            .background(Color(red: 0.98, green: 0.98, blue: 1))
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            pageState.onAppear()
            FamilyGroupManager.shared.loadAll()
        }
    }
    
    
}

private extension MenuMainPage {
    func getUserName(_ usesNewLine: Bool = true) -> String {
        guard let name = pageState.currentUser?.profile?.name else { return "--" }
        let splitted = name.split(separator: " ")
        if splitted.count > 1 {
            return splitted.joined(separator: usesNewLine ? "\n" : " ")
        }
        return pageState.currentUser?.profile?.fullName ?? "--"
    }
    
    func getHeight() -> String {
        let height = pageState.currentUser?.profile?.height ?? 0.0
        return String(Int(height))
    }
    
    func getWeight() -> String {
        let weight = pageState.currentUser?.profile?.weight ?? 0.0
        return String(Int(weight))
    }
    
    func getBirthdate() -> String {
        guard let date = pageState.currentUser?.profile?.birthdayDate else { return "--" }
        // guard let age = user.profile?.age else { return "--" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let string = formatter.string(from: date)
        
        let yearsInterval = abs(date.timeIntervalSince(Date()))
        let years = yearsInterval / (3600 * 24 * 365.25)
        
        let yShort = locStr("y.")
        
        return string + " (\(Int(years)) \(yShort))"
    }
    
    func getGender() -> String {
        let gender = pageState.currentUser?.profile?.gender
        return gender?.localized.capitalized ?? "--"
    }
    
    func buildProfileCard() -> some View {
        ZStack {
            VStack(spacing: 15) {
                Color.clear
                    .frame(height: 50)
                Text(getUserName(false))
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
                AvatarView(user: pageState.realmUserModel?.model())
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
