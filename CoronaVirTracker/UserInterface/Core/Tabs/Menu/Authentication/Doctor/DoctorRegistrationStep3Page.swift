//
//  DoctorRegistrationStep3Page.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.08.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct DoctorRegistrationStep3Page: View {
    
    @State private var image: UIImage?
    @State private var pickerIsShown = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        Image("RedLogo")
                            .resizable()
                            .frame(width: 55, height: 55, alignment: .center)
                            .padding(20)
                        Text("Крок 3 з 3")
                            .font(CustomFonts.createInter(weight: .medium, size: 18))
                        Text("Завершення реєстрації")
                            .font(CustomFonts.createInter(weight: .medium, size: 18))
                            .multilineTextAlignment(.center)
                        Color.clear
                            .frame(height: 80)
                        
                        Button {
                            pickerIsShown = true
                        } label: {
                            VStack(alignment: .center, spacing: 15) {
                                if image == nil {
                                    Image("doctor_placeholder_photo")
                                        .resizable()
                                        .frame(width: 100, height: 100, alignment: .center)
                                } else {
                                    Image(uiImage: image!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .scaledToFill()
                                        .cornerRadius(50)
                                }
                                
                                Text(image == nil ? "Завантажити світлину" : "Змінити світлину")
                                    .font(CustomFonts.createInter(weight: .regular, size: 15))
                                    .foregroundColor(Color(Style.Stroke.blue))
                                    .underline()
                            }
                        }

                        
                    }
                }
                AppRedButtonTabView(title: "Завершити") {
                    
                }
            }
            .background(Color(red: 0.98, green: 0.99, blue: 1))
        }
        .navigationBarHidden(true)
    }
}
