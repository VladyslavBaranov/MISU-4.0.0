//
//  DoctorPage.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 09.06.2022.
//

import SwiftUI

struct DoctorPage: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 250))
    ]
    
    @State var doctor: Doctor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack(spacing: 20) {
                if doctor.avatarName.isEmpty {
                    ZStack {
                        Color.clear
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(40)
                            .overlay(
                                Circle()
                                    .stroke(Color(Style.Stroke.lightGray), lineWidth: 1)
                            )
                        Text(doctor.initials())
                            .font(CustomFonts.createInter(weight: .bold, size: 23))
                            .foregroundColor(Color(Style.TextColors.commonText))
                    }
                } else {
                    Image(doctor.avatarName)
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .cornerRadius(40)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor.fullName)
                        .font(CustomFonts.createInter(weight: .semiBold, size: 18))
                        .foregroundColor(Color(Style.TextColors.commonText))
                    Text(doctor.doctor_category)
                        .font(CustomFonts.createInter(weight: .regular, size: 15))
                        .foregroundColor(Color(Style.TextColors.gray))
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            
                        Text(doctor.location)
                            .font(CustomFonts.createInter(weight: .regular, size: 15))
                            .foregroundColor(Color(Style.TextColors.gray))
                    }
                    
                }
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    ForEach(doctor.tags, id: \.self) { tag in
                        SelectableCapsuleText(isSelected: .constant(false), text: tag)
                    }
                }
                .frame(height: 40)
            }
            Text(doctor.description)
                .font(CustomFonts.createInter(weight: .regular, size: 15))
                .foregroundColor(Color(Style.TextColors.commonText))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(red: 0.97, green: 0.97, blue: 1, alpha: 1)))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .circular)
                .stroke(Color(Style.Stroke.lightGray), lineWidth: 1)
        )
    }
}
