//
//  ECGInProcessPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 22.03.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct ECGInProcessPage: View {
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
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
                }
                Text("ЕКГ")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(Style.TextColors.commonText))
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            ScrollView {
                VStack(spacing: 30) {
                    HStack {
                        VStack {
                            Text("79")
                                .font(CustomFonts.createInter(weight: .bold, size: 30))
                            Text("уд/хв")
                                .font(CustomFonts.createInter(weight: .regular, size: 16))
                        }
                        Spacer()
                        VStack {
                            Text("131/89")
                                .font(CustomFonts.createInter(weight: .bold, size: 30))
                            Text("уд/хв")
                                .font(CustomFonts.createInter(weight: .regular, size: 16))
                        }
                        Spacer()
                        VStack {
                            Text("91")
                                .font(CustomFonts.createInter(weight: .bold, size: 30))
                            Text("уд/хв")
                                .font(CustomFonts.createInter(weight: .regular, size: 16))
                        }
                    }
                    .padding([.leading, .trailing], 40)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.35, green: 0.55, blue: 1))
                            .frame(height: 44)
                        HStack {
                            Image("ecg-connection-ok")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .padding(.leading, 16)
                            Text("Контакт електрода в порядку")
                                .foregroundColor(.white)
                                .font(CustomFonts.createInter(weight: .medium, size: 14))
                            Spacer()
                        }
                    }
                    
                    Color.gray
                        .frame(height: 100)
                    
                    VStack {
                        Image("ecg-heart")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("Чим більше Ви будете розслаблені емоційно та фізично, тим точнішим буде результат")
                            .font(CustomFonts.createInter(weight: .regular, size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 50)
                    
                    HStack {
                        Text("Вимір ЕКГ..")
                        Spacer()
                        Text("0%")
                    }
                    .font(CustomFonts.createInter(weight: .bold, size: 16))
                    .foregroundColor(Color(Style.TextColors.commonText))
                    
                    ProggressView(proggress: .constant(0))
                        .frame(height: 16)
                }
                .padding(16)
            }
            
            Button {
            } label: {
                Text("Далі")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
                    )
            }
            .frame(width: UIScreen.main.bounds.width, height: 100)
            .padding(.bottom, 70)
            
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }

}

