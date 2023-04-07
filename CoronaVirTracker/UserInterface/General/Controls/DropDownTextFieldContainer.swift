//
//  DropDownTextFieldContainer.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 23.06.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct DropDownTextFieldContainer: View {
    
    let title: String
    let subtitle: String?
    let placeHolder: String?
    @Binding var text: String
    
    @State var data: [String]
    
    @State var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(CustomFonts.createInter(weight: .regular, size: 14))
                .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
            RoundedRectText(text: $text)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 8, style: .circular).fill(.white))
                .onTapGesture {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }
            
            VStack(alignment: .leading) {
                ForEach(data, id: \.self) { value in
                    HStack {
                        Text(value)
                            .multilineTextAlignment(.leading)
                            .font(CustomFonts.createInter(weight: .regular, size: 14))
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    text = value
                                    isExpanded.toggle()
                                }
                            }
                            .padding()
                        Spacer()
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: isExpanded ? .infinity : 0)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8, style: .circular).stroke(Color(white: 0.8), lineWidth: 0.3))
            .opacity(isExpanded ? 1 : 0)
            
            if subtitle != nil {
                Text(subtitle!)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
            }
        }
    }
}
