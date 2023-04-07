//
//  AssistantActivationStep5Page.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 03.07.2022.
//

import SwiftUI

struct AssistantActivationStep5Page: View {
    
    var popTapped: (() -> ())?
    
    var numberActivationIsPresented: (() -> ())?
    
    @State private var punct1Agree = false
    @State private var punct2Agree = false
    @State private var punct3Agree = false
    @State private var punct4Agree = false
    @State private var punct5Agree = false
    
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
                            // cancelTapped?()
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
                
                VStack(spacing: 8) {
                    
                    Text("Крок 5 з 5")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
                    Text("Ознайомлення та погодження\nз умовами страхування")
                        .multilineTextAlignment(.center)
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .foregroundColor(Color(Style.TextColors.commonText))
                }

                ZStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Color.clear
                            .frame(height: 5)
                        
                        Group {
                            Text("Зверніть увагу!")
                                .font(CustomFonts.createInter(weight: .medium, size: 18))
                            
                            buildPunct("Вік застрахованої особи має становити 18-65 років")
                            buildPunct("Страхова сума на одну застраховану особу складає 50 000 грн/рік")
                            buildPunct("Період страхування становить 1 рік")
                            
                        }
                        
                        Color.clear
                            .frame(height: 5)
                        
                        Group {
                            Text("Страховкою передбачено:")
                                .font(CustomFonts.createInter(weight: .medium, size: 18))
                            buildPunct("Телемедицина — онлайн консультації терапевта/сімейного лікаря/педіатра, вузьких спеціалістів (безлімітно);")
                            buildPunct("Швидка медична допомога:\n\nа) Виклик швидкої допомоги: виїзд карети швидкої медичної допомоги в межах 30 км від міста;\n\nб) Первинний огляд лікаря, постановка попереднього діагнозу, надання невідкладної допомоги за життєвими показами (купування гострих (критичних) станів; невідкладна медикаментозна терапія;\n\nв) Транспортування до медичного закладу;\n\nг) Госпіталізація в стаціонарне відділення")
                        }
                        
                        Color.clear
                            .frame(height: 10)
                        
                        Group {
                            HStack(spacing: 13) {
                                Button {
                                    punct1Agree.toggle()
                                } label: {
                                    Image(punct1Agree ?  "square-sel" : "square-uns")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Text("Погоджуюсь з усім")
                                    .multilineTextAlignment(.leading)
                            }
                            
                            HStack(spacing: 13) {
                                Button {
                                    punct2Agree.toggle()
                                } label: {
                                    Image(punct2Agree ?  "square-sel" : "square-uns")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Text("Я ознайомлений з Законом України «Про захист персональних даних» і надаю згоду на обробку персональних даних")
                                    .multilineTextAlignment(.leading)
                            }
                            
                            HStack(spacing: 13) {
                                Button {
                                    punct3Agree.toggle()
                                } label: {
                                    Image(punct3Agree ?  "square-sel" : "square-uns")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Button {
                                } label: {
                                    Text("Підтверджую дані, визначені в\nДекларації про ")
                                    + Text("стан здоров’я")
                                        .foregroundColor(Color(Style.Stroke.blue))
                                        .underline()
                                }
                                .multilineTextAlignment(.leading)
                            }
                            
                            HStack(spacing: 13) {
                                Button {
                                    punct4Agree.toggle()
                                } label: {
                                    Image(punct4Agree ?  "square-sel" : "square-uns")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Button {
                                } label: {
                                    Text("Ознайомлений та згоден з публічною\nофертою ")
                                    + Text("Альфа Страхування")
                                        .foregroundColor(Color(Style.Stroke.blue))
                                        .underline()
                                        
                                }
                                .multilineTextAlignment(.leading)
                            }
                            
                            HStack(spacing: 13) {
                                Button {
                                    punct5Agree.toggle()
                                } label: {
                                    Image(punct5Agree ?  "square-sel" : "square-uns")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Button {
                                } label: {
                                    Text("Ознайомлений з публічною офертою ")
                                    + Text("MISU")
                                        .foregroundColor(Color(Style.Stroke.blue))
                                        .underline()
                                }
                                .multilineTextAlignment(.leading)
                            }
                            
                        }
                        .font(CustomFonts.createInter(weight: .regular, size: 14))

                        Color.clear
                            .frame(height: 5)
                        
                        Text("* Настикаючи на чек-бокс, Ви надаєте згоду на обробку персональних даних відповідно до «Закону України Про захист персональних даних» і публічної оферти СК «Альфа Страхування»")
                            .font(CustomFonts.createInter(weight: .regular, size: 14))
                            .foregroundColor(Color(Style.TextColors.gray))
                            .multilineTextAlignment(.leading)
                        
                        Color.clear
                            .frame(height: 5)
                    }
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                    .foregroundColor(Color(Style.TextColors.commonText))
                    .multilineTextAlignment(.leading)
                    .padding()
                    Color.clear
                        .frame(height: 100)
                }
                .background(Color(red: 0.97, green: 0.98, blue: 1).cornerRadius(14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .circular)
                        .stroke(Color(Style.Stroke.lightGray), lineWidth: 1)
                )
                .padding()
                
                
                Color.clear
                    .frame(height: 160)
            }
            
            AppRedButtonTabView(title: "Далі") {
                
                guard punct1Agree && punct2Agree else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                guard punct3Agree && punct4Agree && punct5Agree else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                numberActivationIsPresented?()
                
                AssistantManager.shared.activate(AssistantActivationState.shared.toServerModel())
            }
    
        }
        .background(Color(red: 0.984, green: 0.988, blue: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    private func buildPunct(_ text: String) -> some View {
        HStack {
            VStack {
                Circle()
                    .fill(Color(red: 0.36, green: 0.61, blue: 0.97, opacity: 0.5))
                    .frame(width: 7, height: 7, alignment: .top)
                    .offset(x: 0, y: 6)
                Spacer()
            }
            
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.system(size: 16))
            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true)
    }

}

final class AssistantActivationStep5Controller: UIHostingController<AssistantActivationStep5Page>, AssistanceNavigation {
    
    var navId: String = "ID5"
    
    private var runOnce = false
    
    override init(rootView: AssistantActivationStep5Page) {
        super.init(rootView: rootView)
        self.rootView.popTapped = popTapped
        self.rootView.numberActivationIsPresented = presentNumberActivation
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentNumberActivation() {
        let vc = NumberActivationHostingController(rootView: .init())
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func cancelTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    func popTapped() {
        guard let nav = navigationController else { return }
        AssistantNavigationManager.popToID(id: "ID3", navController: nav)
    }
}

extension AssistantActivationStep5Controller: NumberActivationHostingControllerDelegate {
    func shouldPushToCompletedView() {
        if !runOnce {
            let vc = CompletedActivationController(rootView: .init())
            navigationController?.pushViewController(vc, animated: true)
        }
        runOnce = true
    }
}
