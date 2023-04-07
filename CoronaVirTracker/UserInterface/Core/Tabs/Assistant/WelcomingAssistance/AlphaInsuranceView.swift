//
//  AlphaInsuranceView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct AlphaInsuranceView: View {
    var body: some View {
        VStack(spacing: 40) {
    
            Image("vuso")
                .resizable()
                .scaledToFit()
                .frame(width: 170)
                .padding(.top, 30)
            
            VStack(spacing: 10) {
                Text("VUSO Страхування")
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .multilineTextAlignment(.center)
                Text("Партнер MISU з піклування\nпро ваше здоров’я")
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 10) {
                Image("as-market")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("22 роки")
                    .font(CustomFonts.createInter(weight: .bold, size: 16))
                Text("На страховому ринку України")
            }
            .padding([.leading, .trailing], 16)
            
            VStack(spacing: 10) {
                Image("as-top")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("ТОП-5")
                    .font(CustomFonts.createInter(weight: .bold, size: 16))
                Text("З медичного страхування")
            }
            .padding([.leading, .trailing], 16)
            
            VStack(spacing: 10) {
                Image("as-partners")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("+10 500")
                    .font(CustomFonts.createInter(weight: .bold, size: 16))
                Text("Медичних партнерів")
            }
            .padding([.leading, .trailing], 16)
            
            VStack(spacing: 10) {
                Image("as-clients")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("1 000 000")
                    .font(CustomFonts.createInter(weight: .bold, size: 16))
                Text("Клієнтів, що довіряють компані")
            }
            .padding([.leading, .trailing], 16)
            
            VStack(spacing: 10) {
                Image("as-finance")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("uaAA+")
                    .font(CustomFonts.createInter(weight: .bold, size: 16))
                Text("Дуже високий рівень фінансової\nнадійності")
            }
            .padding([.leading, .trailing], 16)
            
            Color.clear
                .frame(height: 10)
        }
        .font(CustomFonts.createInter(weight: .regular, size: 16))
        .foregroundColor(Color(Style.TextColors.commonText))
        .multilineTextAlignment(.center)
        .background(Color(red: 0.96, green: 0.96, blue: 1).cornerRadius(14))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .circular)
                .stroke(Color(red: 0.89, green: 0.94, blue: 1), lineWidth: 0.6)
        )
        .padding()
    }
}
