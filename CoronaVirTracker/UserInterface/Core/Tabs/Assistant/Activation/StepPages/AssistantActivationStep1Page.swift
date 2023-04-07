//
//  AssistantActivationStep1Page.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 27.06.2022.
//

import SwiftUI
import Combine

struct AssistantActivationStep1Page: View {
    
    @ObservedObject var nameField = FormField(validator: .emptyCheck)
    @ObservedObject var birthdateField = FormField(validator: .date)
    @ObservedObject var phoneField = FormField(validator: .phoneNumber, defaultValue: "+380")
    @ObservedObject var emailField = FormField(validator: .email)
    
    var popTapped: (() -> ())?
    var cancelTapped: (() -> ())?
    var nextTapped: (() -> ())?
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            ScrollView {
                ZStack {
                    HStack {
                        Button {
                            popTapped?()
                        } label: {
                            Image("orange_back")
                        }
                        Spacer()
                        Button {
                            cancelTapped?()
                        } label: {
                            Text("Скасувати")
                                .foregroundColor(Color(Style.TextColors.mainRed))
                                .font(CustomFonts.createInter(weight: .regular, size: 16))
                        }
                    }
                    Text("Активація\nАсистента")
                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                        .foregroundColor(Color(Style.TextColors.commonText))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
                .padding()
                Color.clear
                    .frame(height: 20)
                VStack {
                    
                    Text("Крок 1 з 5")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .foregroundColor(Color(Style.TextColors.gray))
                    Text("Введіть основні дані")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .foregroundColor(Color(Style.TextColors.commonText))
                        .padding()
                    VStack(alignment: .leading, spacing: 16) {
                        
                        TextFieldContainer(
                            formField: nameField,
                            style: .plain,
                            title: "ПІБ *",
                            subtitle: nil,
                            placeHolder: nil,
                            errorMessage: "Неправильно введене імʼя. Введіть ще раз"
                        )
                        .onTapGesture {}
                        TextFieldContainer(
                            formField: birthdateField,
                            style: .plain,
                            title: "Дата народження *",
                            subtitle: nil,
                            placeHolder: "DD.MM.YYYY",
                            errorMessage: "Неправильний формат дати. Введіть ще раз"
                        )
                        .onTapGesture {}
                        TextFieldContainer(
                            formField: phoneField,
                            style: .countrySelection,
                            title: "Номер телефона *",
                            subtitle: nil,
                            placeHolder: nil,
                            errorMessage: "Невірний формат номера телефона. Введіть ще раз"
                        )
                        .onTapGesture {}
                        TextFieldContainer(
                            formField: emailField,
                            style: .plain,
                            title: "E-mail *",
                            subtitle: "* Обов’язкове поле. На ваш e-mail ми надішлемо поліс страхування",
                            placeHolder: nil,
                            errorMessage: "Невірний формат e-mail. Введіть ще раз"
                        )
                        .onTapGesture {}
                    }.padding()
                    Spacer()
                }
                Color.clear
                    .frame(height: 450)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            
            
            AppRedButtonTabView(title: "Далі") {
                nameField.validate()
                birthdateField.validate()
                phoneField.validate()
                emailField.validate()
                
                guard nameField.isValidated && birthdateField.isValidated && emailField.isValidated else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                AssistantActivationState.shared.generalData = .init(
                    fullName: nameField.value,
                    birthdate: birthdateField.value,
                    phoneNumber: phoneField.value,
                    email: emailField.value
                )
                nextTapped?()
            }
        }
        .background(Color(red: 0.97, green: 0.98, blue: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    func shouldDisableNextButton() -> Bool {
        phoneField.value.isEmpty || birthdateField.value.isEmpty || phoneField.value.isEmpty || emailField.value.isEmpty
    }
}

final class AssistantActivationStep1Controller: UIHostingController<AssistantActivationStep1Page>, AssistanceNavigation {

    var navId: String = "ID1"
    
    override init(rootView: AssistantActivationStep1Page) {
        super.init(rootView: rootView)
        self.rootView.popTapped = popTapped
        self.rootView.nextTapped = nextTapped
        self.rootView.cancelTapped = cancelTapped
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextTapped() {
        let step2 = AssistantActivationStep2Controller(rootView: AssistantActivationStep2Page())
        navigationController?.pushViewController(step2, animated: true)
    }
    
    func cancelTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    func popTapped() {
        navigationController?.popViewController(animated: true)
    }
}
