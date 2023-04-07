//
//  SuccessPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 12.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct SuccessPage: View {
    
    let title: String
    let description: String
    var didTapButton: (() -> ())?
    
    @Environment(\.presentationMode) var mode
    
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    Image("CompletedActivationWoman")
                        .resizable()
                        .scaledToFit()
                        .padding(32)
                    VStack(spacing: 12) {
                        Text(title)
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                        Text(description)
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
                
                AppRedButtonTabView(title: "Готово") {
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
