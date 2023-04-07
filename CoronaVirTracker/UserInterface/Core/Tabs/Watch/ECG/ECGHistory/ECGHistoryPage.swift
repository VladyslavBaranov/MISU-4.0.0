//
//  ECGHistoryPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 22.03.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct ECGHistoryItemView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.89, green: 0.94, blue: 1), lineWidth: 1)
                .frame(height: 75)
            HStack(spacing: 16) {
                Color(red: 0.36, green: 0.6, blue: 0.97)
                    .frame(width: 10)
                Text("Загроз не виявлено")
                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                Spacer()
                VStack {
                    Text("23:12")
                    Text("18:43")
                }
                .font(CustomFonts.createInter(weight: .regular, size: 14))
                .padding(.trailing, 16)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ECGHistoryPage: View {
    
    @Environment(\.presentationMode) var mode
    
    var onStartMeasurement: (() -> ())?
    
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
                Text("Історія записів ЕКГ")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(Style.TextColors.commonText))
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("Грудень 2022")
                            .font(CustomFonts.createInter(weight: .semiBold, size: 18))
                        ECGHistoryItemView()
                        ECGHistoryItemView()
                    }
                }
                .padding(16)
            }
            
            Button {
                onStartMeasurement?()
            } label: {
                Text("Розпочати вимір")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
                    )
            }
            .frame(width: UIScreen.main.bounds.width, height: 100)
            .padding(.bottom, 70)
            
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }

}

final class ECGHistoryHostingController: UIHostingController<ECGHistoryPage> {
    
    override init(rootView: ECGHistoryPage) {
        super.init(rootView: rootView)
        self.rootView.onStartMeasurement = { [weak self] in
            let vc = UIHostingController(rootView: ECGFingerPressPage())
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
