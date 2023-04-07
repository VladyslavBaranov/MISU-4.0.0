//
//  ReportPage3.swift
//  ProjectForTesting
//
//  Created by Vladyslav Baranov on 11.02.2023.
//

import SwiftUI

struct ReportPage3: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(spacing: 8) {
                    Text("Ваша норма")
                        .font(.system(size: 14, weight: .regular))
                    Text("70")
                        .font(.system(size: 22, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                VStack(spacing: 8) {
                    Text("Показник за тиждень")
                        .font(.system(size: 14, weight: .regular))
                    HStack {
                        Text("70")
                            .font(.system(size: 22, weight: .bold))
                        Text("+4")
                            .font(.system(size: 22, weight: .bold))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 22, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .frame(height: 290)
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Динаміка серцевого ритму")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Text("21-27 грудня")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        HStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 8, height: 8)
                            Text("Моя днаміка")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Circle()
                                .fill(Color(white: 0.8))
                                .frame(width: 8, height: 8)
                            Text("Інші користувачі")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(16)
            }
            .frame(height: 290)
            
            HStack {
                VStack(spacing: 8) {
                    Text("Динаміка за 7 днів")
                        .font(.system(size: 14, weight: .regular))
                    HStack {
                        Text("+4")
                            .font(.system(size: 22, weight: .bold))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 22, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)
                VStack(spacing: 8) {
                    Text("Динаміка за 28 днів")
                        .font(.system(size: 14, weight: .regular))
                    HStack {
                        Text("+2")
                            .font(.system(size: 22, weight: .bold))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 22, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .padding([.leading, .top, .trailing], 16)
    }
}
