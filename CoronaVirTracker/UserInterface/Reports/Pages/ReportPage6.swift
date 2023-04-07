//
//  ReportPage6.swift
//  ProjectForTesting
//
//  Created by Vladyslav Baranov on 11.02.2023.
//

import SwiftUI
 
struct ReportPage5: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Консультація лікаря")
                        .font(.system(size: 28, weight: .bold))
                    Text("Вчасне звернення до лікаря дозволить вам попередити можливі критичні захворювання, або ранні стадії")
                        .font(.system(size: 16, weight: .regular))
                }
                Spacer()
            }
            Spacer()
            Image("report-consultation")
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
                        Text("Запис на консультацію")
                            .font(.system(size: 15, weight: .semibold))
                    }
                }
                
                Text("30% користувачів консультуються з лікарем")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(height: 54)
                
            }
        }
        .padding(EdgeInsets(top: 30, leading: 16, bottom: 0, trailing: 16))
    }
}
