//
//  MenuMainSubscriptionView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 10.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct MenuMainSubscriptionView: View {
    
    let action: () -> ()
    
    var body: some View {
        ZStack {
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Сімейний доступ")
                        .font(CustomFonts.createInter(weight: .bold, size: 18))
                        .foregroundColor(Color.white)
                    
                    Text("Ви завжди будете знати\nпро стан здоровʼя і ризик\nваших рідних")
                        .font(CustomFonts.createInter(weight: .regular, size: 14))
                        .foregroundColor(Color.white)
                    Color.clear
                        .frame(height: 1)
                    Button {
                        action()
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.white)
                            Text("Активувати")
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                .foregroundColor(Color(red: 0.39, green: 0.44, blue: 0.93))
                                .padding(8)
                        }
                        .frame(width: 120, height: 40)
                    }

                }
                Spacer()
                Image("sub-pic-6")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
            .padding(16)
        }
        .background(
            LinearGradient(
                colors: [.init(red: 0.53, green: 0.61, blue: 1), .init(red: 0.43, green: 0.48, blue: 1)],
                startPoint: .init(x: 0, y: 0),
                endPoint: .init(x: 1, y: 1)
            )
        )
        .cornerRadius(12)
        .padding(16)
    }
}
