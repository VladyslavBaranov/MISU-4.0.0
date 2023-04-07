//
//  WatchMainECGView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.03.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct WatchMainECGView: View {
    
    var onNext: (() -> ())?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.89, green: 0.94, blue: 1), lineWidth: 1)
            VStack {
                HStack {
                    Text("На основі вашого ЕКГ Ви отримаєте прогноз ризиків серцево-судинної системи та оцінку роботи організму")
                        .multilineTextAlignment(.leading)
                        .font(CustomFonts.createInter(size: 14))
                    Spacer()
                    Image("ecg-start-mainpage")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                .padding([.trailing, .leading], 16)
                
                Button {
                    onNext?()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(red: 1, green: 0.37, blue: 0.37))
                            .frame(width: 180, height: 40)
                        Text("Розпочати вимір")
                            .foregroundColor(.white)
                            .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                    }
                    .padding(.bottom, 16)
                }
            }
            
        }
    }
}
