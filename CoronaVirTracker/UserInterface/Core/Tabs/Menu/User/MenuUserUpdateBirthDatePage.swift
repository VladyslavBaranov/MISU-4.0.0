//
//  MenuUserUpdateBirthDatePage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct MenuUserUpdateBirthDatePage: View {
    
    var user: RealmUserModel!
    
    @Environment(\.presentationMode) var mode
    
    @State var date: Date = Date()
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Color(red: 0.98, green: 0.99, blue: 1)
                .frame(height: 30)
            
            AppCancelSaveNavigationBar(title: locStr("Date of birth")) {
                mode.wrappedValue.dismiss()
            } onSave: {
                user.update(.birthDate(date))
                NotificationManager.shared.post(.didUpdateCurrentUser)
                mode.wrappedValue.dismiss()
            }
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(white: 0.94), lineWidth: 1)
                        .background(Color(red: 0.97, green: 0.98, blue: 1))
                    
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .fixedSize()
                    
                    
                }
                .padding(16)
            }.fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .onAppear {
            date = user.model()?.profile?.birthdayDate ?? Date()
        }
    }
    
}


