//
//  PressureCalibrationStep1Page.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 20.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct PressureCalibrationStep1Page: View {
    
    @State private var systolic = 120
    @State private var diastolic = 80
    
    var onCancel: (() -> ())?
    var onNext: ((Int, Int) -> ())?
    
    var body: some View {
        ZStack {
            AppRedButtonTabView(title: "Далі") {
                onNext?(systolic, diastolic)
            }
            VStack {
                AppCancelNavigationBar(title: "Калібрування\nтиску") {
                    onCancel?()
                }
                .padding(.top, 16)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Крок 1")
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                Text("За допомогою тонометра виміряйте ваш тиск та вкажіть результат")
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                    .foregroundColor(Color(Style.TextColors.gray))
                
                DoublePicker(value1: $systolic, value2: $diastolic)
                    .frame(height: 216)
                    .padding(.top, 16)
                /*
                HStack {
                    //ZStack {
                    //    RoundedRectangle(cornerRadius: 12, style: .continuous)
                    //        .stroke(Color(white: 0.94), lineWidth: 1)
                    //        .background(Color(red: 0.97, green: 0.98, blue: 1))
                        
                        Picker("", selection: $systolic) {
                            ForEach(0...300, id: \.self) { index in
                                Text("\(index)").tag(index)
                            }
                        }
                        //.frame(maxWidth: (UIScreen.main.bounds.width - 32) / 2)
                        //.clipped()
                        .pickerStyle(WheelPickerStyle())
                        //.compositingGroup()
                    //}
                    //.fixedSize(horizontal: false, vertical: true)
                    //ZStack {
                    //    RoundedRectangle(cornerRadius: 12, style: .continuous)
                    //        .stroke(Color(white: 0.94), lineWidth: 1)
                    //        .background(Color(red: 0.97, green: 0.98, blue: 1))
                        
                        Picker("", selection: $diastolic) {
                            ForEach(0...300, id: \.self) { index in
                                Text("\(index)").tag(index)
                            }
                        }
                        //.frame(maxWidth: (UIScreen.main.bounds.width - 32) / 2)
                        //.clipped()
                        .pickerStyle(WheelPickerStyle())
                        //.compositingGroup()
                    //}
                    //.fixedSize(horizontal: false, vertical: true)
                }
                //.frame(width: UIScreen.main.bounds.width - 32)
                .padding(.top, 16)
                 */
            }
            .frame(maxWidth: UIScreen.main.bounds.width)
            .padding(16)
            
        }
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .navigationBarHidden(true)
    }
}

final class PressureCalibrationStep1Controller: UIHostingController<PressureCalibrationStep1Page> {
    
    override init(rootView: PressureCalibrationStep1Page) {
        super.init(rootView: rootView)
        self.rootView.onCancel = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
        self.rootView.onNext = { [weak self] sys, dia in
            let vc = PressureCalibrationStep2Controller(rootView: PressureCalibrationStep2Page(systolic: sys, diastolic: dia))
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
