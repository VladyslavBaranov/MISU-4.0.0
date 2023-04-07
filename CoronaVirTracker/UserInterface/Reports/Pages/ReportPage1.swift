//
//  ReportPage1.swift
//  ProjectForTesting
//
//  Created by Vladyslav Baranov on 11.02.2023.
//

import SwiftUI

struct ReportPage1: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Серцевий ритм")
                        .font(.system(size: 22, weight: .bold))
                    Text("Показник став вище порівнянно з минулим тижнем")
                        .font(.system(size: 14, weight: .regular))
                }
                Spacer()
            }
            HStack {
                Text("70 > 74")
                    .font(.system(size: 60, weight: .bold))
                Text("+4")
                    .font(.system(size: 22, weight: .bold))
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
            }
            .padding([.top, .bottom], 30)
            Color.white.opacity(0.5)
                .frame(height: 1.5)
            
            ReportGraphView(values: [70, 69, 65, 60, 67, 71, 74])
                .frame(height: 185)
                .padding(.top, 16)
            
            Spacer()
            
            VStack {
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 27, style: .continuous)
                            .fill(Color.white)
                            .frame(height: 54)
                        Text("Отримати звіт")
                            .font(.system(size: 15, weight: .semibold))
                    }
                }
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 27, style: .continuous)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(height: 54)
                        Text("Що робити?")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(16)
    }
}
