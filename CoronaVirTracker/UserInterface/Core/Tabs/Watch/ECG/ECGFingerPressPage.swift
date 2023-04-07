//
//  ECGFingerPressPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.03.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct ECGFingerPressPage: View {
    
    var onNext: (() -> ())?
    
    @Environment(\.presentationMode) var mode
    
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
                Text("ЕКГ")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(Style.TextColors.commonText))
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            Spacer()
            
            VStack {
                ZStack { // reader in
                    Image("ecg-watchdevice")
                        .resizable()
                        .frame(width: 116, height: 313)
                    ZStack {
                        DeviceTouchPulseView()
                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                    }
                    .offset(x: 116 / 2, y: 240)
                }
                .frame(width: 116, height: 313)
                Text("Прикладіть палець до металевого сенсору\nта тримайте до закінчення виміру\nяк показано на зображені")
                    .multilineTextAlignment(.center)
                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                    .foregroundColor(Color(Style.TextColors.gray))
            }
            
            Spacer()
            
            Button {
                onNext?()
            } label: {
                Text("Далі")
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

final class ECGFingerPressHostingController: UIHostingController<ECGFingerPressPage> {
    override init(rootView: ECGFingerPressPage) {
        super.init(rootView: rootView)
        self.rootView.onNext = { [weak self] in
            let vc = UIHostingController(rootView: ECGInProcessPage())
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
