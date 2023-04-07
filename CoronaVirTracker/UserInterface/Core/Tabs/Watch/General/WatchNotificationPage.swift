//
//  WatchNotificationPage.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 12.07.2022.
//

import SwiftUI

struct WatchNotificationPage: View {
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        VStack(alignment: .center, spacing: 20) {
                            Image("NotificationAttention")
                                .frame(width: 72, height: 72)
                            Text(locStr("nm_str_2"))
                                .font(CustomFonts.createInter(weight: .bold, size: 22))
                                .multilineTextAlignment(.center)
                            Text(locStr("nm_str_3"))
                                .font(CustomFonts.createInter(weight: .regular, size: 16))
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(Color(Style.TextColors.commonText))
                        .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        Color(red: 1, green: 0.96, blue: 0.96).cornerRadius(14)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .circular)
                            .stroke(Color(Style.TextColors.mainRed), lineWidth: 0.6)
                    )
                    .padding(16)
                    
                    Text(locStr("nm_str_6"))
                        .font(CustomFonts.createInter(weight: .regular, size: 14))
                        .foregroundColor(.gray)
                        .padding([.trailing, .leading], 16)
                }
                .offset(x: 0, y: -40)
                
                VStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Button {
                            call()
                        } label: {
                            Text(locStr("nm_str_4"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                                .background(
                                    Capsule(style: .circular)
                                        .fill(Color(Style.TextColors.mainRed))
                                )
                        }
                        .padding(.top, 24)
                        
                        Button {
                            mode.wrappedValue.dismiss()
                        } label: {
                            Text(locStr("nm_str_5"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                .foregroundColor(Color(Style.TextColors.mainRed))
                        }
                        
                        Color.white
                            .frame(height: proxy.safeAreaInsets.bottom)
                    }.background(Color.white)
                }.ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Text(locStr("nm_str_1"))
                        .foregroundColor(Color(Style.TextColors.commonText))
                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                        .padding(25)
                    Spacer()
                }
            }
            .background(Color(red: 0.98, green: 0.98, blue: 1))
        }
    }
    
    func call() {
        if let phoneCallURL = URL(string: "tel://+380674962499") {
            print("URL")
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                print("CALL")
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                print("CANNOT CALL")
            }
        } else {
            print("NO URL")
        }
    }
}
