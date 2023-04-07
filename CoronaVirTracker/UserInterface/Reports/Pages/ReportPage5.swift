//
//  ReportPage5.swift
//  ProjectForTesting
//
//  Created by Vladyslav Baranov on 11.02.2023.
//

import SwiftUI
 
struct ReportPage6: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Профілактичні методи")
                        .font(.system(size: 28, weight: .bold))
                    Text("Користувачі, які виконують профілактичні методи, мають на 30% менший ризик критичних захворювань")
                        .font(.system(size: 16, weight: .regular))
                }
                Spacer()
            }
            Spacer()
            Image("report-prevention")
                .resizable()
                .frame(width: 280, height: 280)
            Spacer()
            VStack {
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 27, style: .continuous)
                            .fill(Color.white)
                            .frame(height: 54)
                        Text("Отримати рекомендації")
                            .font(.system(size: 15, weight: .semibold))
                    }
                }
                
                Text("70% користувачів слідкують рекомендаціям")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(height: 54)
                
            }
        }
        .padding(EdgeInsets(top: 30, leading: 16, bottom: 0, trailing: 16))
    }
}
