//
//  NotificationsPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 23.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct NotificationsPage: View {
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Spacer()
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Text("Готово")
                            .foregroundColor(Color(Style.TextColors.mainRed))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                    }
                }
                Text("Сповіщення")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .foregroundColor(Color(Style.TextColors.commonText))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 30, trailing: 16))
            
            ScrollView {
                
                
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
