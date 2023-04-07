//
//  PressureCalibrationStep2Page.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 20.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

final class PressureCalibrationStep2State: ObservableObject {
    
    enum RunningState: Equatable {
        case notRunning, success, error
    }
    
    @Published var state = RunningState.notRunning
    
    @Published var isPerformingCalibration = false
    
    func finishCalibration(_ systolic: Int, _ diastolic: Int) {
        
        isPerformingCalibration = true
        
        /*
         
         Here is logic
         
         Upon finishing calibration set state value to something and set isPerformingCalibration to true (INSIDE MAIN THREAD)
         
         */
        
        
    }
}

struct PressureCalibrationStep2Page: View {
    
    let systolic: Int
    let diastolic: Int
    
    var onCancel: (() -> ())?
    
    @ObservedObject var state = PressureCalibrationStep2State()
    
    var body: some View {
        ZStack {
            
            VStack {
                AppCancelNavigationBar(title: "Калібрування\nтиску") {
                    onCancel?()
                }
                .padding(.top, 16)
                Spacer()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(state.state == .success ? Color(red: 0.38, green: 0.65, blue: 1) : Color(red: 1, green: 0.48, blue: 0.47))
                            .frame(height: 50)
                        HStack {
                            Image(systemName: state.state == .success ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            Text(state.state == .success ? "Успіх" : "Помилка")
                        }
                        .font(CustomFonts.createInter(weight: .regular, size: 14))
                        .foregroundColor(.white)
                    }
                    .opacity(state.state == .notRunning ? 0 : 1)
                    
                    Text("Крок 2")
                        .font(CustomFonts.createInter(weight: .bold, size: 22))
                    Text("Розпочніть вимір на вашому девайсі")
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                        .foregroundColor(Color(Style.TextColors.gray))
                    Image("calibration-step2")
                        .resizable()
                        .scaledToFit()
                }
                .padding(16)
            }
            
            AppRedButtonTabProgressView(title: "Завершити калібрування", isRunningAction: $state.isPerformingCalibration) {
                state.finishCalibration(systolic, diastolic)
            }
            
        }
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .navigationBarHidden(true)
        .onChange(of: state.state) { newValue in
            if newValue == PressureCalibrationStep2State.RunningState.success {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    onCancel?()
                }
            }
        }
        .onAppear {
            print(systolic, diastolic)
        }
    }
}

final class PressureCalibrationStep2Controller: UIHostingController<PressureCalibrationStep2Page> {
    
    override init(rootView: PressureCalibrationStep2Page) {
        super.init(rootView: rootView)
        self.rootView.onCancel = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
