//
//  DoctorRegistrationStep2Page.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 06.08.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

private struct Tag {
    let text: String
    var isSelected = false
}

struct DoctorRegistrationStep2Page: View {
    
    @ObservedObject var specialityField = FormField(validator: .emptyCheck)
    
    @State var step3Pushed = false
    
    @State private var tags: [Tag] = [
        .init(text: "Діти 0-16 р."),
        .init(text: "Діти 0-3 р."),
        .init(text: "Діти 7-16 р"),
        .init(text: "Дорослі"),
        .init(text: "Covid-19")
    ]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    Image("RedLogo")
                        .resizable()
                        .frame(width: 55, height: 55, alignment: .center)
                        .padding(20)
                    Text("Крок 2 з 3")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                    Text("Завершення реєстрації")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .multilineTextAlignment(.center)
                    
                    Color.clear
                        .frame(height: 10)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        DropDownTextFieldContainer(
                            title: "Оберіть спеціалізацію",
                            subtitle: nil, placeHolder: nil,
                            text: $specialityField.value,
                            data: ["Сімейний лікар", "Ендокринолог", "Педіатр"]
                        )
                        Color.clear
                            .frame(height: 40)
                        Text("Оберіть 3 теги, що характеризують Вашу діяльність")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                        Color.clear
                            .frame(height: 15)
                        MultilineHStack(
                            id: \.self,
                            alignment: .leading,
                            horizontalSpacing: 6,
                            verticalSpacing: 6
                        ) {
                            ForEach(0..<tags.count, id: \.self) { index in
                                SelectableCapsuleText(
                                    isSelected: $tags[index].isSelected, text: tags[index].text)
                                .onTapGesture {
                                    tags[index].isSelected.toggle()
                                }
                            }
                        }
                    }
                    .padding(16)
                    Color.clear
                        .frame(height: 160)
                    
                }
                
                
            }
            .frame(maxWidth: .infinity)
            
            NavigationLink(isActive: $step3Pushed) {
                DoctorRegistrationStep3Page()
            } label: {
                EmptyView()
            }
            
            AppRedButtonTabView(title: "Далі") {
                
                specialityField.validate()
                
                guard specialityField.isValidated else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                let selectedCount = tags.filter { $0.isSelected }.count
                guard selectedCount == 3 else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                step3Pushed = true
            }
        }
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .navigationBarHidden(true)
    }
}

