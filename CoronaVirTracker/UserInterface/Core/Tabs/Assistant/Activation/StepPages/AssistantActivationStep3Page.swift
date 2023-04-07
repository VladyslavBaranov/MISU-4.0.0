//
//  AssistantActivationStep3Page.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 27.06.2022.
//

import SwiftUI

struct AssistantActivationStep3Page: View {
    
    @ObservedObject var ipnField = FormField(validator: .ipn)
    @ObservedObject var passportTypeField = DropDownFormField(
        validator: .emptyCheck, list: ["ID-картка", "Паспорт громадянина України"])
    
    @ObservedObject var passportSerialNumberField = FormField(validator: .uaPassportSerial)
    @ObservedObject var passportNumberField = FormField(validator: .emptyCheck)
    
    @ObservedObject var idPassportNumber = FormField(validator: .emptyCheck)
    @ObservedObject var givenByField = FormField(validator: .emptyCheck)
    @ObservedObject var givenTimeField = FormField(validator: .emptyCheck)
    
    @State var addressList: [String] = ["1", "2"]
    
    @State var didReadDataPrivacy = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var popTapped: (() -> ())?
    var cancelTapped: (() -> ())?
    var nextTapped: (() -> ())?
    
    var body: some View {
        GeometryReader { proxy in
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
                        
                        Text("Крок 3 з 5")
                            .font(CustomFonts.createInter(weight: .medium, size: 18))
                            .foregroundColor(Color(Style.TextColors.gray))
                        Text("Введіть ІПН і дані паспорта")
                            .font(CustomFonts.createInter(weight: .medium, size: 18))
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .padding()
                        VStack(alignment: .leading, spacing: 16) {
                            
                            TextFieldContainer(
                                formField: ipnField,
                                style: .plain,
                                title: "ІПН *",
                                subtitle: nil,
                                placeHolder: nil,
                                errorMessage: "Неправильно введено ІПН. Введіть ще раз"
                            )
                            .onTapGesture {}
                            DropDownTextFieldContainer(
                                title: "Оберіть вид паспорта *",
                                subtitle: nil,
                                placeHolder: nil,
                                text: $passportTypeField.value,
                                data: passportTypeField.list
                            )
                            
                            if passportTypeField.value.contains("ID") {
                                TextFieldContainer(
                                    formField: idPassportNumber,
                                    style: .plain,
                                    title: "Номер паспорта *",
                                    subtitle: nil,
                                    placeHolder: nil,
                                    errorMessage: "Неправильно введено номер паспорта. Введіть ще раз"
                                )
                                .onTapGesture {}
                            } else {
                                HStack(spacing: 13) {
                                    TextFieldContainer(
                                        formField: passportSerialNumberField,
                                        style: .plain,
                                        title: "Серія паспорта *",
                                        subtitle: nil,
                                        placeHolder: nil,
                                        errorMessage: ""
                                    )
                                    .onTapGesture {}
                                    TextFieldContainer(
                                        formField: passportNumberField,
                                        style: .plain,
                                        title: "Номер паспорта *",
                                        subtitle: nil,
                                        placeHolder: nil,
                                        errorMessage: ""
                                    )
                                    .onTapGesture {}
                                }
                            }
                            
                            HStack(spacing: 13) {
                                TextFieldContainer(
                                    formField: givenByField,
                                    style: .plain,
                                    title: "Ким виданий *",
                                    subtitle: nil,
                                    placeHolder: nil,
                                    errorMessage: ""
                                )
                                .onTapGesture {}
                                TextFieldContainer(
                                    formField: givenTimeField,
                                    style: .plain,
                                    title: "Коли виданий *",
                                    subtitle: nil,
                                    placeHolder: nil,
                                    errorMessage: ""
                                )
                                .onTapGesture {}
                            }
                            Text("* Обов’язкове поле. Ці дані необхідні для оформлення ")
                                .font(CustomFonts.createInter(weight: .regular, size: 14))
                                .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
                            + Text("медичного полісу")
                                .font(CustomFonts.createInter(weight: .semiBold, size: 14))
                                .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
                            
                            
                        }.padding()
                        Spacer()
                    }
                    Color.clear
                        .frame(height: 350)
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                
                AppRedButtonTabView(title: "Далі") {
                    ipnField.validate()
                    passportSerialNumberField.validate()
                    idPassportNumber.validate()
                    passportTypeField.validate()
                    
                    passportNumberField.validate()
                    givenByField.validate()
                    givenTimeField.validate()
                    
                    guard ipnField.isValidated && passportSerialNumberField.isValidated && idPassportNumber.isValidated else {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        return
                    }
                    
                    nextTapped?()
                    
                    AssistantActivationState.shared.identityData = .init(
                        ipn: ipnField.value,
                        passportType: passportTypeField.value,
                        passportNumber: ""
                    )
                }
            }
            .background(Color(red: 0.97, green: 0.98, blue: 1))
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
    
    func shouldDisableNextButton() -> Bool {
        ipnField.value.isEmpty || passportTypeField.value.isEmpty || passportNumberField.value.isEmpty || passportSerialNumberField.value.isEmpty
    }
    
    func buildPrivacyProtection() -> some View {
        Text("Я ознайомлений з Законом України ") +
        Text("«Про захист персональних даних» ")
            .foregroundColor(Color(red: 93.0 / 255, green: 155.0 / 255, blue: 248.0 / 255)).underline() +
        Text("і надаю згоду на обробку персональних даних")
    }
}

final class AssistantActivationStep3Controller: UIHostingController<AssistantActivationStep3Page>, AssistanceNavigation {
    
    var navId: String = "ID3"
    
    override init(rootView: AssistantActivationStep3Page) {
        super.init(rootView: rootView)
        self.rootView.popTapped = popTapped
        self.rootView.nextTapped = nextTapped
        self.rootView.cancelTapped = cancelTapped
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextTapped() {
        let step4 = AssistantActivationStep4Controller(rootView: AssistantActivationStep4Page())
        navigationController?.pushViewController(step4, animated: true)
    }
    
    func cancelTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    func popTapped() {
        guard let nav = navigationController else { return }
        AssistantNavigationManager.popToID(id: "ID2", navController: nav)
    }
}
