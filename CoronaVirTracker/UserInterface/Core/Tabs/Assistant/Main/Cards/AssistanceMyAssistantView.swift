//
//  AssistanceMyAssistantView.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 29.06.2022.
//

import SwiftUI

struct AssistanceHealthDataScrollView: View {
    
    @State var samples: [HKTypeIdStruct] = []
    
    var onCharacteristicTapped: (() -> ())?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                AssistanceHealthDataCard(
                    data: .init(
                        dataEntityName: locStr("mah_str_8"),
                        value: "120/80",
                        unit: locStr("mah_str_18"),
                                colors: [Color(red: 1, green: 0.55, blue: 0.55), Color(red: 1, green: 0.37, blue: 0.37)]))
                    .frame(width: 150)
                    .onTapGesture {
                        onCharacteristicTapped?()
                    }
                AssistanceHealthDataCard(
                    data: .init(
                        dataEntityName: locStr("mah_str_9"),
                        value: "5,9",
                        unit: locStr("mah_str_11"),
                                colors: [Color(red: 0.48, green: 0.71, blue: 1), Color(red: 0.29, green: 0.6, blue: 1)]))
                    .frame(width: 150)
                    .onTapGesture {
                        onCharacteristicTapped?()
                    }
                AssistanceHealthDataCard(
                    data: .init(
                        dataEntityName: locStr("mah_str_10"),
                        value: "77",
                        unit: locStr("mah_str_12"),
                                colors: [Color(red: 1, green: 0.5, blue: 0.53), Color(red: 1, green: 0.41, blue: 0.44)]))
                    .frame(width: 150)
                    .onTapGesture {
                        onCharacteristicTapped?()
                    }
                AssistanceHealthDataCard(
                    data: .init(
                        dataEntityName: locStr("hc_str_7"),
                        value: "98%",
                        unit: locStr("gen_str_7"),
                                colors: [Color(red: 0.38, green: 0.65, blue: 1), Color(red: 0.31, green: 0.49, blue: 0.95)]))
                    .frame(width: 150)
                    .onTapGesture {
                        onCharacteristicTapped?()
                    }
                AssistanceHealthDataCard(
                    data: .init(
                        dataEntityName: locStr("hc_str_8"),
                        value: "36,6 °C", unit: locStr("gen_str_7"),
                                colors: [Color(red: 1, green: 0.74, blue: 0.65), Color(red: 1, green: 0.671, blue: 0.56)]))
                    .frame(width: 150)
                    .onTapGesture {
                        onCharacteristicTapped?()
                    }
            }.padding([.leading, .trailing], 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.width * 0.4)
    }
}

struct AssistanceMyAssistantView: View {
    
    private var onOnlineDoctorTapped: (() -> ())?
    private var onRiskGroupTapped: (() -> ())?
    
    var body: some View {
        HStack(spacing: 13) {
            /*
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: RoundedCornerStyle.continuous)
                    .stroke(Color(white: 0.85), lineWidth: 0.5)
                    .background(Color(red: 0.95, green: 0.97, blue: 1).cornerRadius(12))
                    
                VStack(spacing: 10) {
                    Image("onlineDoc")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 170)
                        .frame(maxWidth: .infinity)
                    Text(locStr("mah_str_14"))
                        .font(CustomFonts.createInter(weight: .semiBold, size: 17))
                        .foregroundColor(Color(Style.TextColors.commonText))
                }.padding()
            }.onTapGesture {
                onOnlineDoctorTapped?()
            }
            */
            
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: RoundedCornerStyle.continuous)
                    .stroke(Color(white: 0.85), lineWidth: 0.5)
                    .background(Color(red: 0.95, green: 0.97, blue: 1).cornerRadius(12))
                VStack(spacing: 10) {
                    Image("riskGroup")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 170)
                        .frame(maxWidth: .infinity)
                        
                    Text(locStr("mah_str_15"))
                        .font(CustomFonts.createInter(weight: .semiBold, size: 17))
                        .foregroundColor(Color(Style.TextColors.commonText))
                }.padding()
            }
            .frame(width: (UIScreen.main.bounds.width - 48) / 2)
            .onTapGesture {
                onRiskGroupTapped?()
            }
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.width * 0.55)
        .padding([.leading, .trailing], 16)
    }
    
    func onOnlineDoctorTapped(_ action: @escaping () -> ()) -> AssistanceMyAssistantView {
        AssistanceMyAssistantView(onOnlineDoctorTapped: action, onRiskGroupTapped: onRiskGroupTapped)
    }
    
    func onRiskGroupTapped(_ action: @escaping () -> ()) -> AssistanceMyAssistantView {
        AssistanceMyAssistantView(onOnlineDoctorTapped: onOnlineDoctorTapped, onRiskGroupTapped: action)
    }
}
