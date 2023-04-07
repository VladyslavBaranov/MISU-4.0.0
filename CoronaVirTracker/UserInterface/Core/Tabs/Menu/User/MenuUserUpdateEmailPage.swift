//
//  MenuUserUpdateEmailPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct MenuUserUpdateEmailPage: View {
    
    var user: RealmUserModel!
    
    @ObservedObject var emailField = FormField(validator: .emptyCheck)
    
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
                        // let email = emailField.value
                        // user.updateEmail(email)
                        mode.wrappedValue.dismiss()
                    } label: {
                        Text(locStr("Done"))
                            .foregroundColor(Color(Style.TextColors.mainRed))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                    }
                }
                Text("E-mail")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color(red: 0.98, green: 0.99, blue: 1))
            .foregroundColor(.black)
            ScrollView {
                VStack {
                    TextFieldContainer(
                        formField: emailField,
                        style: .plain,
                        title: "E-mail",
                        subtitle: nil,
                        placeHolder: nil,
                        errorMessage: ""
                    )
                }
                .padding(16)
            }
            
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .onAppear {
            // emailField.value = user?.email ?? "--"
        }
    }
    
}

