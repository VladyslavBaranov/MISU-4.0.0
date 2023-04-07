//
//  HealthDataListPage.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 12.07.2022.
//

import SwiftUI

fileprivate struct Item {
    let iconName: String
    let title: String
}

struct HealthDataListCell: View {
    
    fileprivate let item: Item
    
    var body: some View {
        HStack(spacing: 12) {
            Image(item.iconName)
                .resizable()
                .frame(width: 50, height: 50)
            Text(item.title)
                .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                .foregroundColor(Color(Style.TextColors.commonText))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color(Style.TextColors.gray))
        }
        .padding([.top, .bottom], 8)
    }
}

struct HealthDataListPage: View {
    
    @Environment(\.presentationMode) var mode
    
    private let items: [Item] = [
        .init(iconName: "sleep", title: locStr("hc_str_2")),
        .init(iconName: "steps", title: locStr("hc_str_3")),
        .init(iconName: "blood-pressure", title: locStr("hc_str_4")),
        .init(iconName: "blood-sugar", title: locStr("hc_str_5")),
        .init(iconName: "heart-rate", title: locStr("hc_str_6")),
        .init(iconName: "oxygen", title: locStr("hc_str_7")),
        .init(iconName: "temperature", title: locStr("hc_str_8")),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 30)
            ZStack {
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("orange_back")
                            .font(.system(size: 24))
                    }
                    Spacer()
                }
                Text(locStr("hc_str_1"))
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(Style.TextColors.commonText))
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            List {
                ForEach(0..<items.count, id: \.self) { index in
                    HealthDataListCell(item: items[index])
                }
            }
            .listStyle(PlainListStyle())
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}
