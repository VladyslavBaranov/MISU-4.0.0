//
//  ExpandableTextCard.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 12.07.2022.
//

import SwiftUI

struct ExpandableTextCard: View {
    @State var textIsExpanded = false
    
    let text: String
    let buttonTitle: String
    
    var body: some View {
        VStack {
            Text(textIsExpanded ? "\(String(text.prefix(150))).." : text)
                .multilineTextAlignment(.leading)
                .font(CustomFonts.createInter(weight: .regular, size: 16))
                .foregroundColor(Color(Style.TextColors.commonText))
                .padding()
            
            Button {
                withAnimation(.linear(duration: 0.3)) {
                    textIsExpanded.toggle()
                }
            } label: {
                Text(buttonTitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.red)
                    .frame(width: UIScreen.main.bounds.width - 64, height: 54)
                    .background(
                        Capsule(style: .circular)
                            .stroke(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)), lineWidth: 1)
                    )
            }
            Color.clear
                .frame(height: 20)
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 32)
        .background(Color(red: 0.98, green: 0.98, blue: 1).cornerRadius(14))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .circular)
                .stroke(Color(.systemGray4), lineWidth: 0.5)
        )
        .padding([.trailing, .leading], 16)
    }
}
