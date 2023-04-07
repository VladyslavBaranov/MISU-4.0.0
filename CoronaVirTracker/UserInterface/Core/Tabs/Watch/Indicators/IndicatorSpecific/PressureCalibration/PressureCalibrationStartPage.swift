//
//  PressureCalibrationStartPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 20.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct PressureCalibrationStartPage: View {
    
    var onNext: (() -> ())?
    var onCancel: (() -> ())?
    
    var body: some View {
        ZStack {
            AppRedButtonTabView(title: "Далі") {
                onNext?()
            }
            VStack {
                AppCancelNavigationBar(title: "Калібрування\nтиску") {
                    onCancel?()
                }
                .padding(.top, 16)
                Spacer()
            }
            
            ZStack {
                VStack(spacing: 40) {
                    Image("calibration-pressure-start")
                        .scaledToFit()
                    VStack(spacing: 20) {
                        Text(locStr("Для визначення Вашої  норми показників"))
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                            .bold()
                            .multilineTextAlignment(.center)
                        Text(locStr("Відкалібруйте девайс, за допомогою тонометра"))
                            .multilineTextAlignment(.center)
                    }
                    
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
            }
            .frame(maxWidth: .infinity)
            .font(CustomFonts.createInter(weight: .regular, size: 16))
            .foregroundColor(Color(Style.TextColors.commonText))
            .multilineTextAlignment(.center)
            .background(Color(red: 0.98, green: 0.98, blue: 1).cornerRadius(14))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .circular)
                    .stroke(Color.blue, lineWidth: 0.6)
            )
            .padding(16)
            
        }
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .navigationBarHidden(true)
    }
}

final class PressureCalibrationStartController: UIHostingController<PressureCalibrationStartPage> {
    
    override init(rootView: PressureCalibrationStartPage) {
        super.init(rootView: rootView)
        self.rootView.onNext = { [weak self] in
            self?.pushStep1()
        }
        self.rootView.onCancel = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pushStep1() {
        let vc = PressureCalibrationStep1Controller(rootView: PressureCalibrationStep1Page())
        navigationController?.pushViewController(vc, animated: true)
    }
}
