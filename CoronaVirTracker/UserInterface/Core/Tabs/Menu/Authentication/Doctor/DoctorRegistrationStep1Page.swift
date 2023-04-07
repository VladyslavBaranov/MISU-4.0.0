//
//  DoctorRegistrationStep1Page.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 04.08.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct DoctorRegistrationStep1Page: View {
    
    @ObservedObject var firstName = FormField(validator: .emptyCheck)
    @ObservedObject var lastName = FormField(validator: .emptyCheck)
    @ObservedObject var patronymic = FormField(validator: .emptyCheck)
    @ObservedObject var birthdateField = FormField(validator: .date)
    @ObservedObject var cityField = FormField(validator: .emptyCheck)
    
    @State var step2Pushed = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    Image("RedLogo")
                        .resizable()
                        .frame(width: 55, height: 55, alignment: .center)
                        .padding(20)
                    Text("Крок 1 з 3")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .foregroundColor(Color(Style.TextColors.gray))
                    Text("Завершення реєстрації")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .multilineTextAlignment(.center)
                    Text("Введіть ваші основні дані, щоб завершити процес реєстрації *")
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                        .multilineTextAlignment(.center)
                    
                    Color.clear
                        .frame(height: 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        TextFieldContainer(
                            formField: lastName,
                            style: .plain,
                            title: "Прізвище",
                            subtitle: nil,
                            placeHolder: nil,
                            errorMessage: "Будь-ласка, введіть прізвище повністю"
                        )
                        .onTapGesture {}
                        
                        TextFieldContainer(
                            formField: firstName,
                            style: .plain,
                            title: "Імʼя",
                            subtitle: nil,
                            placeHolder: nil,
                            errorMessage: "Будь-ласка, введіть ім’я повністю"
                        )
                        .onTapGesture {}
                        
                        TextFieldContainer(
                            formField: patronymic,
                            style: .plain,
                            title: "По батькові",
                            subtitle: nil,
                            placeHolder: nil,
                            errorMessage: "Будь-ласка, введіть по-батькові повністю"
                        )
                        .onTapGesture {}
                        
                        TextFieldContainer(
                            formField: birthdateField,
                            style: .plain,
                            title: "Дата народження",
                            subtitle: nil,
                            placeHolder: "DD.MM.YYYY",
                            errorMessage: "Неправильний формат дати. Введіть ще раз"
                        )
                        .onTapGesture {}
                        
                        TextFieldContainer(
                            formField: cityField,
                            style: .plain,
                            title: "Місто",
                            subtitle: nil,
                            placeHolder: "",
                            errorMessage: "Порожнє місто. Введіть ще раз"
                        )
                        .onTapGesture {}
                        
                        Text("* Всі поля обов’язкові для заповнення")
                            .foregroundColor(Color(Style.TextColors.gray))
                            .font(CustomFonts.createInter(weight: .regular, size: 14))
                            .offset(x: 0, y: 20)
                        
                    }
                    .padding(16)
                    Color.clear
                        .frame(height: 160)
                    
                }
                
                
            }
            .frame(maxWidth: .infinity)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            
            NavigationLink(isActive: $step2Pushed) {
                DoctorRegistrationStep2Page()
            } label: {
                EmptyView()
            }
            
            AppRedButtonTabView(title: "Далі") {
                firstName.validate()
                lastName.validate()
                patronymic.validate()
                birthdateField.validate()
                cityField.validate()
                
                guard cityField.isValidated else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                guard firstName.isValidated && lastName.isValidated && patronymic.isValidated && birthdateField.isValidated else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                step2Pushed = true
            }
        }
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .navigationBarHidden(true)
    }
    
    func shouldDisableNextButton() -> Bool {
        firstName.value.isEmpty || lastName.value.isEmpty || patronymic.value.isEmpty || birthdateField.value.isEmpty
    }
}
