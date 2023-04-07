//
//  ChatStartPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct ChatStartPage: View {
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    Image("chat-start-woman")
                        .padding(30)
                    VStack(spacing: 18) {
                        
                        Text("Медична домопога від\nАсистента в чаті MISU!")
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .multilineTextAlignment(.center)
                        
                        Text("В чаті Ви может звернутись за допомогою до Асистента,  а також проконсультуватись з лікарем")
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 5)
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 36, trailing: 16))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .circular)
                        .stroke(Color.blue, lineWidth: 0.6)
                        .frame(width: UIScreen.main.bounds.width - 32)
                )
                .padding()
            }
            .navigationBarHidden(true)
            .offset(x: 0, y: -40)
            
            AppRedButtonTabView(title: "Розпочати") {
                mode.wrappedValue.dismiss()
            }
        }
        .ignoresSafeArea()
        .background(Color(red: 0.98, green: 0.98, blue: 1))
        .onAppear {
            KeyStore.saveValue(true, for: .didShowChatStart)
        }
    }
}
