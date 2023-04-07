//
//  IntensiveMonitoringIntervalPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 15.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct IntensiveMonitoringIntervalPage: View {
    
    @State var selectedInterval = 60
    
    @Environment(\.presentationMode) var mode
    
    @State private var failPushed = false
    @State private var successPushed = false
    
    var cancelAction: (() -> ())?
    
    var body: some View {
        GeometryReader { proxy in
            
            NavigationLink(isActive: $failPushed) {
                FailPage(
                    title: "Інтенсивний моніторинг\nздоров’я не активовано",
                    errorDescription: "Годинник не підключено до додатку. Підключіть годинник, щоб увімкнути режим інтенсивного моніторингу"
                ) {
                    cancelAction?()
                }
            } label: {
                EmptyView()
            }
            
            NavigationLink(isActive: $successPushed) {
                SuccessPage(
                    title: "Інтенсивний моніторинг\nздоров’я увімкненно!",
                    description: "Частоту сканування показників Ви завжди можете змінити в налаштуваннях годинника"
                ) {
                    cancelAction?()
                }
            } label: {
                EmptyView()
            }

            ZStack {
                Color(red: 0.98, green: 0.99, blue: 1)
                ScrollView {
                    ZStack {
                        HStack {
                            Button {
                                mode.wrappedValue.dismiss()
                            } label: {
                                Image("orange_back")
                            }
                            Spacer()
                        }
                        Text(locStr("im_str_1"))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }
                    .padding()
                }
                
                VStack {
                    Text("Оновлювати показники кожні:")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color(white: 0.94), lineWidth: 1)
                                .background(Color(red: 0.97, green: 0.98, blue: 1))
                            
                            Picker("", selection: $selectedInterval) {
                                ForEach([15, 30, 60, 120, 180], id: \.self) { index in
                                    Text("\(index)").tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                        }
                        .padding(16)
                    }.fixedSize(horizontal: false, vertical: true)
                    Text("хвилин")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                }
                
                VStack {
                    Spacer()
                    VStack {
                        Button {
                            
                            
                            WatchFakeVPNManager.shared.startFakeWPN { success, error in
                                DispatchQueue.main.async {
                                    if success {
                                        successPushed = true
                                    } else {
                                        failPushed = true
                                        NotificationManager.shared.post(.didForceIntensiveMonitoringToStop)
                                    }
                                }
                            }
                        
                            
                        } label: {
                            Text("Зберегти")
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                                .background(
                                    Capsule(style: .circular)
                                        .fill(Color(Style.TextColors.mainRed))
                                )
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                        
                        Color.white
                            .frame(height: proxy.safeAreaInsets.bottom)
                    }.background(Color.white)
                }.ignoresSafeArea()
            }
        }
        .navigationBarHidden(true)
    }
}

final class IntensiveMonitoringIntervalController: UIHostingController<IntensiveMonitoringIntervalPage> {
    override init(rootView: IntensiveMonitoringIntervalPage) {
        super.init(rootView: rootView)
        self.rootView.cancelAction = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
