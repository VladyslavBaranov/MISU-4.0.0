//
//  RegistrationUserTypeSelectionPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 04.08.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct AuthUserTypeSelectionPage: View {
    
    enum UserType: Int {
        case user = 0, doctor = 1
    }
    
    @State var userType: UserType = .user
    @State var isNextStepShown = false
    
    var onDismiss: (() -> ())?
    var onNextTapped: ((Int) -> ())?
    
    var body: some View {
        ZStack {
            VStack {
                Text(locStr("Choose the type of your profile"))
                    .foregroundColor(Color(Style.TextColors.commonText))
                    .font(CustomFonts.createInter(weight: .medium, size: 18))
                Color.clear
                    .frame(height: 40)
                HStack(spacing: 13) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: RoundedCornerStyle.continuous)
                            .stroke(userType == .user ? Color(Style.Stroke.blue) : Color(white: 0.85), lineWidth: 0.5)
                            .background(Color(red: 0.95, green: 0.97, blue: 1).cornerRadius(12))
                        
                        VStack(spacing: 10) {
                            Image("UserType")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 170)
                                .frame(maxWidth: .infinity)
                            Text(locStr("I am a user"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 17))
                                .foregroundColor(Color(Style.TextColors.commonText))
                        }.padding()
                    }
                    .onTapGesture {
                        userType = .user
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: RoundedCornerStyle.continuous)
                            .stroke(userType == .doctor ? Color(Style.Stroke.blue) : Color(white: 0.85), lineWidth: 0.5)
                            .background(Color(red: 0.95, green: 0.97, blue: 1).cornerRadius(12))
                        
                        VStack(spacing: 10) {
                            Image("DoctorType")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 170)
                                .frame(maxWidth: .infinity)
                            Text(locStr("I am a doctor"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 17))
                                .foregroundColor(Color(Style.TextColors.commonText))
                        }.padding()
                    }
                    .opacity(0.5)
                    // .onTapGesture {
                    //     userType = .doctor
                    // }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 190)
                .padding([.leading, .trailing], 16)
                
            }
            .offset(x: 0, y: -45)
            
            AppRedButtonTabView(title: locStr("Next")) {
                onNextTapped?(userType.rawValue)
            }
            
            VStack {
                HStack {
                    Button {
                        onDismiss?()
                    } label: {
                        Image("orange_back")
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
        }
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .navigationBarHidden(true)
    }
}

final class AuthUserTypeSelectionController: UIHostingController<AuthUserTypeSelectionPage> {
    
    override init(rootView: AuthUserTypeSelectionPage) {
        super.init(rootView: rootView)
        self.rootView.onDismiss = { [weak self] in
            self?.popSelf()
        }
        self.rootView.onNextTapped = { [weak self] type in
            if type == 0 {
                self?.pushUserProfileCreation()
            } else {
                self?.pushDoctorProfileCreation()
            }
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func popSelf() {
        navigationController?.popViewController(animated: true)
    }
    
    private func pushUserProfileCreation() {
        let vc = AuthUserProfileCreationController(rootView: .init())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushDoctorProfileCreation() {
        let vc = UIHostingController(rootView: DoctorRegistrationStep1Page())
        vc.view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
