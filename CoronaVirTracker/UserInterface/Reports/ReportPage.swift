//
//  ReportPage.swift
//  ProjectForTesting
//
//  Created by Vladyslav Baranov on 11.02.2023.
//

import SwiftUI

struct TopRoundRect: Shape {
    func path(in rect: CGRect) -> Path {
        let bezier = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: .init(width: 4, height: 4))
        return Path(bezier.cgPath)
    }
}

struct ReportPage: View {
    
    @State var currentPage = 0
    
    @State private var gradientColors1: [Color] = [
        Color(red: 0.46, green: 0.45, blue: 1), Color(red: 0.26, green: 0.25, blue: 0.83)
    ]
    @State private var gradientColors2: [Color] = []
    
    @State var g1Opacity = 1.0
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: gradientColors2,
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .opacity(1)
            
            LinearGradient(
                colors: gradientColors1,
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .opacity(g1Opacity)
            
            VStack {
                HStack {
                    Text(getTitleForCurrentPage())
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.white)
                            .font(.system(size: 26, weight: .light))
                    }
                }
                .padding(16)
                HStack(spacing: 3) {
                    ForEach(0..<6) { index in
                        if index == currentPage {
                            Color.white
                                .frame(height: 1.5)
                        } else {
                            Color.white.opacity(0.5)
                                .frame(height: 1.5)
                        }
                    }
                }
                .padding([.leading, .trailing], 16)
                TabView(selection: $currentPage) {
                    ReportPage1()
                        .tag(0)
                    ReportPage2()
                        .tag(1)
                    ReportPage3()
                        .tag(2)
                    ReportPage1().tag(3)
                    ReportPage5()
                        .tag(4)
                    ReportPage6()
                        .tag(5)
                }.tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .onChange(of: currentPage) { newPage in
            // withAnimation(.linear(duration: 3)) {
            changeBackground(newPage)
            // }
            withAnimation {
                g1Opacity = g1Opacity == 1 ? 0 : 1
            }
        }
    }
    
    private func changeBackground(_ page: Int) {
        switch page {
        case 0:
            if g1Opacity == 1 {
                gradientColors2 = [
                    Color(red: 0.46, green: 0.45, blue: 1),
                    Color(red: 0.26, green: 0.25, blue: 0.83)
                ]
            } else {
                gradientColors1 = [
                    Color(red: 0.46, green: 0.45, blue: 1),
                    Color(red: 0.26, green: 0.25, blue: 0.83)
                ]
            }
        case 1:
            if g1Opacity == 1 {
                gradientColors2 = [
                    Color(red: 0.34, green: 0.48, blue: 0.97),
                    Color(red: 0.19, green: 0.35, blue: 0.93)
                ]
            } else {
                gradientColors1 = [
                    Color(red: 0.34, green: 0.48, blue: 0.97),
                    Color(red: 0.19, green: 0.35, blue: 0.93)
                ]
            }
        default:
            if g1Opacity == 1 {
                gradientColors2 = [
                    Color(red: 0.5, green: 0.64, blue: 1),
                    Color(red: 0.31, green: 0.5, blue: 0.97)
                ]
            } else {
                gradientColors1 = [
                    Color(red: 0.5, green: 0.64, blue: 1),
                    Color(red: 0.31, green: 0.5, blue: 0.97)
                ]
            }
        }
    }
    
    private func getTitleForCurrentPage() -> String {
        switch currentPage {
        case 0:
            return "Ваша динаміка за тиждень"
        case 1:
            return "Динаміка інших користувачів"
        case 2:
            return "Детальний звіт"
        case 3:
            return "Порівняння з користувачами"
        case 4:
            return "Що робити ?"
        default:
            return "Що робити ?"
        }
    }
}



