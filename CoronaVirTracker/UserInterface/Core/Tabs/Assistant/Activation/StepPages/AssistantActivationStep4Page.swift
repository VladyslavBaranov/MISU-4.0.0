//
//  AssistantActivationStep4Page.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 27.06.2022.
//

import SwiftUI

struct AssistantActivationStep4Page: View {
    
    var popToGeneralTapped: (() -> ())?
    var popToAddressTapped: (() -> ())?
   
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
                                    .foregroundColor(.red)
                                    .font(.system(size: 16))
                            }
                        }
                        Text("Активація\nАсистента")
                            .font(.system(size: 17, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }
                    .padding()
                    Color.clear
                        .frame(height: 20)
                    VStack {
                        
                        Text("Крок 4 з 5")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
                        Text("Перевірка даних")
                            .font(.system(size: 18))
                            .padding()
                        VStack(alignment: .leading, spacing: 16) {
                            
                            HStack {
                                Text("Основні дані")
                                    .font(.system(size: 16, weight: .bold))
                                    .bold()
                                Spacer()
                                Button {
                                    popToGeneralTapped?()
                                } label: {
                                    Image("Pen")
                                }
                                
                            }
                            
                            Group {
                                RoundedRectTextContainer(
                                    title: "ПІБ *", text: AssistantActivationState.shared.generalData.fullName
                                )
                                RoundedRectTextContainer(
                                    title: "Дата народження", text: AssistantActivationState.shared.generalData.birthdate
                                )
                                RoundedRectTextContainer(
                                    title: "Номер телефону", text: AssistantActivationState.shared.generalData.phoneNumber
                                )
                                RoundedRectTextContainer(
                                    title: "E-mail", text: AssistantActivationState.shared.generalData.email
                                )
                            }
                            
                            HStack {
                                Text("Адреса")
                                    .font(.system(size: 16, weight: .bold))
                                    .bold()
                                Spacer()
                                Button {
                                    popToAddressTapped?()
                                } label: {
                                    Image("Pen")
                                }
                                
                            }
                            
                            Group {
                                RoundedRectTextContainer(
                                    title: "Країна", text: AssistantActivationState.shared.addressData.country
                                )
                                RoundedRectTextContainer(
                                    title: "Місто", text: AssistantActivationState.shared.addressData.city
                                )
                                RoundedRectTextContainer(
                                    title: "Спосіб доставки",
                                    text: AssistantActivationState.shared.addressData.deliveryMethod
                                )
                                RoundedRectTextContainer(
                                    title: "Адреса доставки",
                                    text: AssistantActivationState.shared.addressData.deliveryAddress
                                )
                            }
                            
                            HStack {
                                Text("ІПН і дані паспорта")
                                    .font(.system(size: 16, weight: .bold))
                                    .bold()
                                Spacer()
                                Button {
                                    popTapped?()
                                } label: {
                                    Image("Pen")
                                }
                                
                            }
                            
                            Group {
                                RoundedRectTextContainer(
                                    title: "ІПН", text: AssistantActivationState.shared.identityData.ipn
                                )
                                RoundedRectTextContainer(
                                    title: "Вид паспорта", text: AssistantActivationState.shared.identityData.passportType
                                )
                                RoundedRectTextContainer(
                                    title: "Номер паспорта",
                                    text: AssistantActivationState.shared.identityData.passportNumber
                                )
                            }
                            
                        }.padding()
                        Spacer()
                    }
                    Color.clear
                        .frame(height: 160)
                }
                
                AppRedButtonTabView(title: "Далі") {
                    nextTapped?()
                }
            }
            .background(Color(red: 0.984, green: 0.988, blue: 1))
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
    
    func buildPrivacyProtection() -> some View {
        Text("Я ознайомлений з Законом України ") +
        Text("«Про захист персональних даних» ")
            .foregroundColor(Color(red: 93.0 / 255, green: 155.0 / 255, blue: 248.0 / 255)).underline() +
        Text("і надаю згоду на обробку персональних даних")
    }
}

final class AssistantActivationStep4Controller: UIHostingController<AssistantActivationStep4Page>, AssistanceNavigation {
    
    var navId: String = "ID4"
    
    override init(rootView: AssistantActivationStep4Page) {
        super.init(rootView: rootView)
        self.rootView.popTapped = popTapped
        self.rootView.cancelTapped = cancelTapped
        self.rootView.popToGeneralTapped = popToGeneralTapped
        self.rootView.popToAddressTapped = popToAddressTapped
        self.rootView.nextTapped = pushStep5
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    func popTapped() {
        guard let nav = navigationController else { return }
        AssistantNavigationManager.popToID(id: "ID3", navController: nav)
    }
    
    func popToGeneralTapped() {
        guard let nav = navigationController else { return }
        AssistantNavigationManager.popToID(id: "ID1", navController: nav)
    }
    
    func popToAddressTapped() {
        guard let nav = navigationController else { return }
        AssistantNavigationManager.popToID(id: "ID2", navController: nav)
    }
    
    func pushStep5() {
        let vc = AssistantActivationStep5Controller(rootView: .init())
        navigationController?.pushViewController(vc, animated: true)
    }
}
