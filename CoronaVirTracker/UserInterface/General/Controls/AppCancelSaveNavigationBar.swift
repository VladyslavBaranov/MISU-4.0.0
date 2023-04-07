//
//  AppNavigationBar.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 06.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct AppCancelSaveNavigationBar: View {
    
    let title: String
    let onCancel: () -> ()
    let onSave: () -> ()
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    onCancel()
                } label: {
                    Text(locStr("Cancel"))
                        .foregroundColor(Color(Style.TextColors.mainRed))
                        .font(CustomFonts.createInter(weight: .regular, size: 15))
                }
                Spacer()
                Button {
                    onSave()
                } label: {
                    Text(locStr("Save"))
                        .foregroundColor(Color(Style.TextColors.mainRed))
                        .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                }
            }
            Text(title)
                .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                .multilineTextAlignment(.center)
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 30, trailing: 16))
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .foregroundColor(.black)
    }
}

struct AppCancelNavigationBar: View {
    let title: String
    let onCancel: () -> ()
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button {
                    onCancel()
                } label: {
                    Text(locStr("Cancel"))
                        .foregroundColor(Color(Style.TextColors.mainRed))
                        .font(CustomFonts.createInter(weight: .regular, size: 15))
                }
            }
            Text(title)
                .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                .multilineTextAlignment(.center)
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 30, trailing: 16))
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .foregroundColor(.black)
    }
}
