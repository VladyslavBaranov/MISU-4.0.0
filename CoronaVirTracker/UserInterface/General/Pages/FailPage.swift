//
//  MenuFamilyGroupAddNewFailPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 12.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct FailPage: View {
    
    @Environment(\.presentationMode) var mode
    
    let title: String
    let errorDescription: String
    var didTapButton: (() -> ())?
    
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
                        Text(title)
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                        Text(errorDescription)
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .padding([.leading, .trailing], 30)
                    }
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .font(CustomFonts.createInter(weight: .regular, size: 16))
                .foregroundColor(Color(Style.TextColors.commonText))
                .multilineTextAlignment(.center)
                .background(Color(red: 1, green: 0.96, blue: 0.96).cornerRadius(14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .circular)
                        .stroke(Color(Style.TextColors.mainRed), lineWidth: 0.6)
                )
                .padding(16)
                .offset(x: 0, y: -30)
                
                AppRedButtonTabView(title: "Спробувати ще раз") {
                    if didTapButton == nil {
                        mode.wrappedValue.dismiss()
                    } else {
                        didTapButton?()
                    }
                }
            }
            .background(Color(red: 0.97, green: 0.98, blue: 1))
            .navigationBarHidden(true)
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .navigationBarHidden(true)
    }
    

}

