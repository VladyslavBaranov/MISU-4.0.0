//
//  HealthNotificationPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 22.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct NofificationModel {
    let title: String
    let description: String
}

struct HealthNotificationPage: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                VStack {
                    Image("FFail")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .scaledToFit()
                        .padding(32)
                    VStack(spacing: 12) {
                        Text("Помилка відправлення\nзапрошення")
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                        Text("Вказаний номер не є дійсний. Будь\n-ласка, спробуйте надіслати\nзапрошення повторно")
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
                .padding(16)
                .offset(x: 0, y: -30)
                
                VStack {
                    Spacer()
                    ZStack {
                        VStack {
                            Button {
                                // mode.wrappedValue.dismiss()
                            } label: {
                                Text("Спробувати ще раз")
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
            }
            .background(Color(red: 0.97, green: 0.98, blue: 1))
            .navigationBarHidden(true)
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .navigationBarHidden(true)
    }
}

final class HealthNotificationHostingController: UIHostingController<HealthNotificationPage> {
    
    override init(rootView: HealthNotificationPage) {
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
