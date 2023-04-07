//
//  FamilyMemberProfilePage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 08.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct FamilyMemberProfilePage: View {
    
    @State var user: RealmUserModel
    
    @Environment(\.presentationMode) var mode
    
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
                    
                    
                    // MenuProfileHeaderView(profile: user.profile)
                    
                    HStack {
                        Text(Localizer.menuString(.healthIndicators))
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Spacer()
                        Button {
                            
                        } label: {
                            HStack {
                                Text(locStr("More"))
                                Image(systemName: "chevron.right")
                            }
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .foregroundColor(Color(Style.TextColors.mainRed))
                        }
                    }
                    .padding(16)
                    AssistanceHealthDataScrollView()
                    
                    Color.clear
                        .frame(height: 30)
                }
                .background(Color(red: 0.98, green: 0.98, blue: 1))
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}
