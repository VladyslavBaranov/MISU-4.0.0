//
//  AssistanceHowItWorksCard.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 29.06.2022.
//

import SwiftUI

struct AssistanceHowItWorksCard: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.38, green: 0.65, blue: 1),
                    Color(red: 0.31, green: 0.49, blue: 0.95)
                ],
                startPoint: .init(x: 0.5, y: 0),
                endPoint: .init(x: 0.5, y: 1)
            )
            .cornerRadius(12)
            HStack {
                Spacer()
                Image("howItWorksW")
                    .resizable()
					.scaledToFit()
                    .frame(height: 240)
                    .scaledToFit()
                
            }
            .cornerRadius(12)
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Image("logoW")
                        .frame(width: 50, height: 50)
                    Spacer()
                    Text(locStr("mah_str_16"))
                        .font(.system(size: 22, weight: .bold))
                    Text(locStr("mah_str_17"))
                }
                .foregroundColor(.white)
                Spacer()
            }.padding()
        }
        .frame(height: UIScreen.main.bounds.width * 0.55)
        .padding([.leading, .trailing], 16)
    }
}
