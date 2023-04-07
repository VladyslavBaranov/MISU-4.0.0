//
//  WatchGeneralCard.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 08.07.2022.
//

import SwiftUI

struct HealthIndicatorViewModel {
    var title: String
    var value: String
    var unit: String?
    var _indicator: __HealthIndicatorType = .sleep
    var date: Date = Date()
}

struct WatchGeneralCard: View {
    
    let model: HealthIndicatorViewModel
    
    let imageName: String
    let colors: [Color]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: RoundedCornerStyle.continuous)
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .init(x: 0.5, y: 0),
                        endPoint: .init(x: 0.5, y: 1)
                    )
                )
            VStack(alignment: .leading, spacing: 8) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(white: 1, opacity: 0.4))
                        .frame(width: 52, height: 52)
                    Image(imageName)
                }
                
                Color.clear
                    .frame(height: 40)
                
                Text(model.title)
                    .font(CustomFonts.createInter(weight: .bold, size: 18))
                    .foregroundColor(.white)
                // Text(model.date.description)
                //    .font(CustomFonts.createInter(weight: .bold, size: 12))
                //    .foregroundColor(.white)
                Text(model.value)
                    .font(CustomFonts.createInter(weight: .bold, size: 24))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .foregroundColor(.white)
        }
    }
}
