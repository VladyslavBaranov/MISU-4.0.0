//
//  CompletedActivationPage.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 07.07.2022.
//

import SwiftUI

struct CompletedActivationPage: View {
    
    var dismissAction: (() -> ())?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            dismissAction?()
                        } label: {
                            Image(systemName: "multiply")
                                .font(.system(size: 30, weight: .light))
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    Spacer()
                }
                VStack {
                    Spacer()
                    ZStack {
                        VStack {
                            Button {
                                dismissAction?()
                            } label: {
                                Text("Зрозуміло")
                                    .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                                    .background(
                                        Capsule(style: .circular)
                                            .fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
                                    )
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                            Color.clear
                                .frame(height: proxy.safeAreaInsets.bottom)
                        }
                    }
                    .background(Color.white)
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .navigationBarHidden(true)
                
                VStack {
                    Image("CompletedActivationWoman")
                        .resizable()
                        .scaledToFit()
                        .padding(32)
                    VStack(spacing: 12) {
                        Text("Асистент MISU і Браслет\nвідкриті для користування!")
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                        Text("Необмежені можливості слідкування\nза здоров’ям вже доступні для вас!")
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                    }
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .font(CustomFonts.createInter(weight: .regular, size: 16))
                .foregroundColor(Color(Style.TextColors.commonText))
                .multilineTextAlignment(.center)
                .background(Color(red: 0.96, green: 0.96, blue: 1).cornerRadius(14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .circular)
                        .stroke(Color.blue, lineWidth: 0.6)
                )
                .padding()
                .offset(x: 0, y: -30)
            }
            
            
        }
        
    }
}

final class CompletedActivationController: UIHostingController<CompletedActivationPage> {
    
    override init(rootView: CompletedActivationPage) {
        super.init(rootView: rootView)
        self.rootView.dismissAction = dismissAction
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissAction() {
        navigationController?.dismiss(animated: true)
    }
}
