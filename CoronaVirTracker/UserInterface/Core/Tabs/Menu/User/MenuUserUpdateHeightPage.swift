//
//  MenuUserUpdateHeightPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 18.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct MenuUserUpdateHeightPage: View {
    
    var user: RealmUserModel!
    
    @Environment(\.presentationMode) var mode

    @State var selectedHeight = 170
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Color(red: 0.98, green: 0.99, blue: 1)
                .frame(height: 30)
            
            AppCancelSaveNavigationBar(title: locStr("Height")) {
                mode.wrappedValue.dismiss()
            } onSave: {
                user.update(.height(Double(selectedHeight)))
                NotificationManager.shared.post(.didUpdateCurrentUser)
                mode.wrappedValue.dismiss()
            }
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(white: 0.94), lineWidth: 1)
                        .background(Color(red: 0.97, green: 0.98, blue: 1))
                    
                    Picker("", selection: $selectedHeight) {
                        ForEach(120...210, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                }
                .padding(16)
            }.fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .onAppear {
            selectedHeight = Int(user.model()?.profile?.height ?? 0.0)
        }
    }
    
}
