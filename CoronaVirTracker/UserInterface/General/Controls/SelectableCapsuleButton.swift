//
//  SelectableCapsuleButton.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 09.06.2022.
//

import SwiftUI

struct SelectableCapsuleButton: View {
    
    @Binding var isSelected: Bool
    let text: String
    var completion: (Bool, String) -> ()
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                isSelected.toggle()
                completion(isSelected, text)
            } label: {
                Text(text)
                    .font(
                        CustomFonts.createInter(weight: isSelected ? .medium : .regular, size: 14)
                    )
                    .foregroundColor(isSelected ? .white : Color(.appAccent))

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .frame(height: 40)
        .background(getBackground())
        .cornerRadius(20)
        .overlay(
            Capsule(style: .circular)
                .stroke(Color(Style.Stroke.lightGray), lineWidth: isSelected ? 0 : 1)
        )
    }
    
    func getBackground() -> LinearGradient {
        let colors: [Color] = isSelected ? [
            Color(red: 0.38, green: 0.65, blue: 1),
            Color(red: 0.31, green: 0.49, blue: 0.95)
        ] : [.clear]
        
        return LinearGradient(
            colors: colors,
            startPoint: .init(x: 0.5, y: 0),
            endPoint: .init(x: 0.5, y: 1)
        )
    }
}
