//
//  AssistantActivationStep2Page.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 27.06.2022.
//

import SwiftUI

struct AssistantActivationStep2Page: View {
    @ObservedObject var countryField = FormField(validator: .emptyCheck)
    @ObservedObject var cityField = FormField(validator: .emptyCheck)
    @ObservedObject var deliveryMethodField = DropDownFormField(
        validator: .emptyCheck, list: ["Відділення “Нова Пошта”"])
    @ObservedObject var addressField = FormField(validator: .emptyCheck)
    
    // @State var addressList: [String] = ["1", "2"]
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var popTapped: (() -> ())?
    var cancelTapped: (() -> ())?
    var nextTapped: (() -> ())?
    
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
                    
                    Text("Крок 2 з 5")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .foregroundColor(Color(Style.TextColors.gray))
                    Text("Введіть вашу адресу")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .foregroundColor(Color(Style.TextColors.commonText))
                        .padding()
                    VStack(alignment: .leading, spacing: 16) {
                        
                        TextFieldContainer(
                            formField: countryField,
                            style: .plain,
                            title: "Країна *",
                            subtitle: nil,
                            placeHolder: nil,
                            errorMessage: "Неправильно введено країну. Введіть ще раз"
                        )
                        .onTapGesture {}
                        TextFieldContainer(
                            formField: cityField,
                            style: .plain,
                            title: "Місто *",
                            subtitle: nil,
                            placeHolder: nil,
                            errorMessage: "Неправильний формат дати. Введіть ще раз"
                        )
                        .onTapGesture {}
                        DropDownTextFieldContainer(
                            title: "Спосіб доставки *",
                            subtitle: nil,
                            placeHolder: nil,
                            text: $deliveryMethodField.value,
                            data: deliveryMethodField.list
                        )
                        .onTapGesture {}
                        TextFieldContainer(
                            formField: addressField,
                            style: .plain,
                            title: "Адреса доставки *",
                            subtitle: "* Обов’язкове поле. На зазначене відділення згодом ми надішлемо поліс страхування",
                            placeHolder: nil,
                            errorMessage: "Неправильний формат дати. Введіть ще раз"
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
                countryField.validate()
                cityField.validate()
                
                guard countryField.isValidated && cityField.isValidated else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                nextTapped?()
                
                AssistantActivationState.shared.addressData = .init(
                    country: countryField.value,
                    city: cityField.value,
                    deliveryMethod: deliveryMethodField.value,
                    deliveryAddress: addressField.value
                )
            }
        }
        .background(Color(red: 0.97, green: 0.98, blue: 1))
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // cancelButtonTapped?()
                } label: {
                    Text("Скасувати")
                        .foregroundColor(.red)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    Image("orange_back")
                }
            }
            
        }
        .onAppear {
            cityField.onValueChange = { city in
                guard !city.isEmpty else { return }
                NovaPoshtaAPI.shared.lookForWarehouses(in: city) { res in
                    if let res = res {
                        DispatchQueue.main.async {
                            // addressList = res.data.map { $0.Description }
                            // print(addressField.list)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        
    }
    
    func shouldDisableNextButton() -> Bool {
        countryField.value.isEmpty || cityField.value.isEmpty || deliveryMethodField.value.isEmpty || addressField.value.isEmpty
    }
}

final class AssistantActivationStep2Controller: UIHostingController<AssistantActivationStep2Page>, AssistanceNavigation {
    
    var navId: String = "ID2"
    
    override init(rootView: AssistantActivationStep2Page) {
        super.init(rootView: rootView)
        self.rootView.popTapped = popTapped
        self.rootView.cancelTapped = cancelTapped
        self.rootView.nextTapped = nextTapped
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextTapped() {
        let step2 = AssistantActivationStep3Controller(rootView: AssistantActivationStep3Page())
        navigationController?.pushViewController(step2, animated: true)
    }
    
    func cancelTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    func popTapped() {
        guard let nav = navigationController else { return }
        AssistantNavigationManager.popToID(id: "ID1", navController: nav)
    }
}
