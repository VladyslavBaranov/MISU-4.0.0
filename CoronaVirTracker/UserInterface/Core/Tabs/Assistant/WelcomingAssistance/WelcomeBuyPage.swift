//
//  WelcomeBuyPage.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 14.06.2022.
//

import SwiftUI

struct WelcomeBuyPage: View {
    
    let items: [BraceletActivationCard.Item] = [
        .init(
            title: locStr("was_str_8"),
            description: locStr("was_str_9"),
            image: "watchAssis",
            gradient: [
                Color(red: 0.38, green: 0.65, blue: 1),
                Color(red: 0.31, green: 0.49, blue: 0.95)
            ], imagePlacement: .side
        ),
        .init(
            title: locStr("was_str_25"),
            description: locStr("was_str_26"),
            image: "misuCaresYou",
            gradient: [
                Color(red: 0.53, green: 0.57, blue: 0.95),
                Color(red: 0.39, green: 0.44, blue: 0.93)
            ], imagePlacement: .topRight
        ),
        .init(
            title: locStr("was_str_27"),
            description: locStr("was_str_28"),
            image: "healthProtection",
            gradient: [
                Color(red: 0.51, green: 0.77, blue: 1),
                Color(red: 0.31, green: 0.67, blue: 1)
            ], imagePlacement: .topRight
        )
    ]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
			ZStack {
				HStack {
					Button {
						presentationMode.wrappedValue.dismiss()
					} label: {
						Image("orange_back")
					}
					Spacer()
				}.padding(20)
			}
			.frame(maxWidth: .infinity)
			.background(Color.white)
            Text(locStr("was_str_29"))
                .multilineTextAlignment(.center)
                .font(.system(size: 25, weight: .semibold))
                .padding()
            VStack(spacing: 16) {
                BraceletActivationCardItem(item: items[0])
                    .frame(height: UIScreen.main.bounds.width * 0.56)
                BraceletActivationCardItem(item: items[1])
                    .frame(height: UIScreen.main.bounds.width * 0.56)
                BraceletActivationCardItem(item: items[2])
                    .frame(height: UIScreen.main.bounds.width * 0.56)
            }.padding()
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("orange_back")
                }

            }
        }
    }
}
