//
//  MenuUserUpdateGenderPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct MenuUserUpdateGenderPage: View {
    
    var user: RealmUserModel!
    
    @Environment(\.presentationMode) var mode

    @State var selectedGender = 0
    
    let genders = [
        Gender.male.localized.capitalized,
        Gender.female.localized.capitalized
    ]
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Color(red: 0.98, green: 0.99, blue: 1)
                .frame(height: 30)
            
            AppCancelSaveNavigationBar(title: locStr("Gender")) {
                mode.wrappedValue.dismiss()
            } onSave: {
                user.update(.gender(.init(rawValue: selectedGender)!))
                NotificationManager.shared.post(.didUpdateCurrentUser)
                mode.wrappedValue.dismiss()
            }
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(white: 0.94), lineWidth: 1)
                        .background(Color(red: 0.97, green: 0.98, blue: 1))
                    
                    Picker("", selection: $selectedGender) {
                        ForEach(0...1, id: \.self) { index in
                            Text(genders[index]).tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                }
                .padding(16)
            }
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .onAppear {
            selectedGender = user.model()?.profile?.gender.rawValue ?? 0
        }
    }
    
}


