//
//  DoctorDetailsPage.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 13.06.2022.
//

import SwiftUI

struct DoctorDetailsPageProfile: View {
    
    @State var doctor: Doctor
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Text(doctor.fullName)
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .foregroundColor(Color(Style.TextColors.commonText))
                    .bold()
                Text(doctor.doctor_category)
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                    .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.97))
                HStack {
                    Image("location")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        //.tint(.gray)
                    Text(doctor.location)
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                        .foregroundColor(Color(Style.TextColors.gray))
                    
                }
            }.offset(x: 0, y: 10)
            VStack {
                if doctor.avatarName.isEmpty {
                    ZStack {
                        Color.white
                            .frame(width: 90, height: 90, alignment: .center)
                            .cornerRadius(45)
                            .overlay(
                                Circle()
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        Text(doctor.initials())
                            .font(.system(size: 22, weight: .bold, design: .default))
                    }
                    .offset(x: 0, y: -45)
                } else {
                    Image(doctor.avatarName)
                        .resizable()
                        .frame(width: 90, height: 90, alignment: .center)
                        .cornerRadius(45)
                        .offset(x: 0, y: -45)
                }
                Spacer()
            }
            
        }
        
        .frame(maxWidth: UIScreen.main.bounds.width - 32)
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .circular)
                .stroke(Color(.systemGray4), lineWidth: 0.5)
                .background(Color.white)
        )
        //.cornerRadius(12)
        .padding()
    }
}

struct DoctorDescriptionExpandableView: View {
    
    @State var textIsExpanded = false
    
    let text = "Лікар спеціалізується на сімейній медицині. Обслуговує пацієнтів амбулаторно, проводить профілактичні огляди та консультації по здоров'ю та розвитку дитини. Проводить первинний лікарський патронаж новонародженого; вирішує питання грудного вигодовування та введення прикорму; консультації щодо догляду за новонародженими; планові огляди; діагностику та лікування захворювань дітей та дорослих; консультації з приводу вакцинації"
    
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
                Text(textIsExpanded ? locStr("dd_str_3") : locStr("dd_str_6"))
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
        .background(Color.white.cornerRadius(14))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .circular)
                .stroke(Color(.systemGray4), lineWidth: 0.5)
        )
        .padding([.trailing, .leading], 16)
        
    }
}

struct DoctorDetailsPage: View {
    
    @State var doctor: Doctor
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Color.clear
                        .frame(height: 100)
                    DoctorDetailsPageProfile(doctor: doctor)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(doctor.tags, id: \.self) { tag in
                                SelectableCapsuleText(isSelected: .constant(false), text: tag)
                            }
                        }
                        .frame(height: 40)
                    }.padding(.leading, 16)
                    
                    Text(locStr("dd_str_2"))
                        .font(CustomFonts.createInter(weight: .bold, size: 22))
                        .foregroundColor(Color(Style.TextColors.commonText))
                        .bold()
                        .padding([.top, .leading], 16)
                    
                    DoctorDescriptionExpandableView()
                    
                    Color.clear
                        .frame(height: 200)
                }
                
            }
            .navigationBarHidden(true)
            
            VStack {
                Spacer()
                ZStack {
                    VStack(spacing: 12) {
                        Button {
                            print("ACTIVATE")
                        } label: {
                            HStack {
                                Image(systemName: "message")
                                    .foregroundColor(.white)
                                Text(locStr("dd_str_4"))
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                            .background(
                                Capsule(style: .circular)
                                    .fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
                            )
                        }
                        Button {
                            print("ACTIVATE")
                        } label: {
                            HStack {
                                Image(systemName: "phone")
                                    .foregroundColor(.red)
                                Text(locStr("dd_str_5"))
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.red)
                            }
                            
                            .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                            .background(
                                Capsule(style: .circular)
                                    .stroke(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)), lineWidth: 1)
                            )
                        }
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: 170)
                .background(Color.white)
            }
            
            VStack(spacing: 0) {
                Color.white
                    .frame(height: 40)
                ZStack {
                    HStack {
                        Button {
                            mode.wrappedValue.dismiss()
                        } label: {
                            Image("orange_back")
                        }
                        Spacer()
                        Button {
                            print("POP")
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                        }
                    }.padding(20)
                    Text(locStr("dd_str_1"))
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                Spacer()
            }
            .ignoresSafeArea()
        }
        .background(Color(UIColor(red: 0.985, green: 0.985, blue: 1, alpha: 1)))
    }
}
