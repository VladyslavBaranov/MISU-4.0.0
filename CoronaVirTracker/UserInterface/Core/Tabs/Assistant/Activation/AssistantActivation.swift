//
//  AssistantActivation.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 15.06.2022.
//

import SwiftUI

struct AssistantActivationPage: View {
    
    var cancelButtonTapped: (() -> ())?
    var nextTapped: (() -> ())?
    
    var body: some View {
        ZStack {
            ScrollView {
                ZStack {
                    HStack {
                        Spacer()
                        Button {
                            cancelButtonTapped?()
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
                VStack(spacing: 40) {
                    HStack {
                        Image("assisIcon")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .scaledToFit()
                        Image("vuso")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                            
                        Spacer()
                    }
                    .padding()
                    Image("ActivationWoman")
                        .scaledToFit()
                    VStack(spacing: 20) {
                        Text("Активація Асистента MISU майже завершена!")
                            .font(CustomFonts.createInter(weight: .bold, size: 20))
                            .bold()
                            .multilineTextAlignment(.center)
                        Text("Тепер ви будете захищені завдяки Асистенту MISU, а наші лікарі завжди на зв’язку!")
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack {
                        Image("ACT1")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Онлайн консультації лікарів 24/7")
                    }
                    .padding([.leading, .trailing], 16)
                    
                    VStack {
                        Image("ACT2")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Лікар встановлює діагноз, необхідний курс лікування та список медикаментів")
                    }
                    .padding([.leading, .trailing], 16)
                    
                    VStack {
                        Image("ACT3")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Госпіталізація в лікарню, якщо стан здоров’я критичний")
                    }
                    .padding([.leading, .trailing], 16)
                    
                    VStack {
                        Image("ACT4")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Послуга медичної допомоги діє 12 місяців із дати покупки MISU Watch")
                    }
                    .padding([.leading, .trailing], 16)
                    
                    VStack {
                        Image("ACT5")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Виїзд карети швидкої медичної допомоги в межах 30 км від міста")
                    }
                    .padding([.leading, .trailing], 16)
                    
                    VStack {
                        Image("ACT6")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Сума, на яку може бути надана медична допомога протягом року – до 50 000 грн")
                    }
                    .padding([.leading, .trailing], 16)
                    
                    Color.clear
                        .frame(height: 10)
                }
                .font(CustomFonts.createInter(weight: .regular, size: 16))
                .foregroundColor(Color(Style.TextColors.commonText))
                .multilineTextAlignment(.center)
                .background(Color(red: 0.96, green: 0.96, blue: 1).cornerRadius(14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .circular)
                        .stroke(Color.blue, lineWidth: 0.6)
                )
                .padding()
                Color.clear
                    .frame(height: 130)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cancelButtonTapped?()
                    } label: {
                        Text("Скасувати")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            
            AppRedButtonTabView(title: "Активувати Асистент") {
                nextTapped?()
            }
            
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

final class AssistantActivationHostingController: UIHostingController<AssistantActivationPage>, AssistanceNavigation {

    var navId: String = "ID-Main"
    
    override init(rootView: AssistantActivationPage) {
        super.init(rootView: rootView)
        self.rootView.nextTapped = nextTapped
        self.rootView.cancelButtonTapped = cancelTapped
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextTapped() {
        let step1 = AssistantActivationStep1Controller(rootView: AssistantActivationStep1Page())
        navigationController?.pushViewController(step1, animated: true)
    }
    
    func cancelTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    func popTapped() {
        navigationController?.popViewController(animated: true)
    }
}
