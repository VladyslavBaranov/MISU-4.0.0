//
//  SelectableCapsuleText.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 09.06.2022.
//

import SwiftUI

extension UIColor {
    static let appAccent = UIColor(red: 107.0 / 255.0, green: 152.0 / 255.0, blue: 243.0 / 255.0, alpha: 1)
}

struct SelectableCapsuleText: View {
    
    @Binding var isSelected: Bool
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .font(CustomFonts.createInter(weight: isSelected ? .semiBold : .regular, size: 14))
                .foregroundColor(Color(.appAccent))
            
            if isSelected {
                Image(systemName: "multiply")
                    .foregroundColor(Color(UIColor.appAccent))
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(EdgeInsets(top: 7, leading: 16, bottom: 7, trailing: 16))
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            Capsule(style: .circular)
                .stroke(isSelected ? .blue : Color(Style.Stroke.lightGray), lineWidth: 1)
        )
        .fixedSize(horizontal: true, vertical: false)
    }
}
