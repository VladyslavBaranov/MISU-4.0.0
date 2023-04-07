//
//  AppUpdatePage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.11.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct AppUpdatePage: View {
    
    @Environment(\.presentationMode) var mode
    
    let appVersion: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Image("LaunchLogo")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .shadow(
                        color: Color(red: 1, green: 0.44, blue: 0.44, opacity: 0.25),
                        radius: 40
                    )
                Text("MISU")
                    .font(CustomFonts.createInter(weight: .regular, size: 77))
                Text("\(locStr("gui_v")): \(appVersion)")
                    .font(CustomFonts.createInter(weight: .regular, size: 20))
            }
            .foregroundColor(Color(red: 0.11, green: 0.23, blue: 0.38))
            AppRedButtonTabView(title: locStr("gui_update")) {
                guard let url = URL(string: "https://apps.apple.com/ua/app/misu/id1516509504") else {
                    return
                }
                guard UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Text(locStr("wc_str_4"))
                            .font(CustomFonts.createInter(weight: .regular, size: 15))
                            .foregroundColor(Color(Style.TextColors.mainRed))
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
}
