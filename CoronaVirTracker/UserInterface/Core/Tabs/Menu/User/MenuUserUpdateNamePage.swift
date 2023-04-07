//
//  UpdateNamePage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 08.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct UpdateNamePage: View {
    
    var user: RealmUserModel!
    
    @ObservedObject var firstNameField = FormField(validator: .emptyCheck)
    @ObservedObject var secondNameField = FormField(validator: .emptyCheck)
    @ObservedObject var patronymicField = FormField(validator: .emptyCheck)
    
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
                        let s1 = firstNameField.value.trimmingCharacters(in: .whitespaces)
                        let s2 = secondNameField.value.trimmingCharacters(in: .whitespaces)
                        let s3 = patronymicField.value.trimmingCharacters(in: .whitespaces)
                        
                        let name = "\(s1) \(s2) \(s3)"
                        
                        firstNameField.validate()
                        secondNameField.validate()
                        
                        guard firstNameField.isValidated && secondNameField.isValidated else {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            return
                        }
                        
                        user.update(.name(name))
                        NotificationManager.shared.post(.didUpdateCurrentUser)
                        mode.wrappedValue.dismiss()
                    } label: {
                        Text(locStr("Done"))
                            .foregroundColor(Color(Style.TextColors.mainRed))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                    }
                }
                Text(locStr("User profile"))
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color(red: 0.98, green: 0.99, blue: 1))
            .foregroundColor(.black)
            ScrollView {
                VStack(spacing: 20) {
                    TextFieldContainer(
                        formField: firstNameField,
                        style: .plain,
                        title: locStr("First name"),
                        subtitle: nil,
                        placeHolder: nil,
                        errorMessage: locStr("Invalid name format")
                    )
                    
                    TextFieldContainer(
                        formField: secondNameField,
                        style: .plain,
                        title: locStr("Last name"),
                        subtitle: nil,
                        placeHolder: nil,
                        errorMessage: locStr("Incorrect last name format")
                    )
                    
                    TextFieldContainer(
                        formField: patronymicField,
                        style: .plain,
                        title: locStr("Paternal name"),
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
            firstNameField.value = user.model()?.profile?.name ?? "";
            secondNameField.value = user.model()?.profile?.second_name ?? "";
            patronymicField.value = user.model()?.profile?.family_name ?? "";
        }
    }
    
}

