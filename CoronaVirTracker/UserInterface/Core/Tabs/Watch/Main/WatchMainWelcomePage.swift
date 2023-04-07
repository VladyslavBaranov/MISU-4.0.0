//
//  WatchMainWelcomePage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 20.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct WatchMainWelcomePage: View {
    
    @Environment(\.presentationMode) var mode
    
    var didTapConnect: (() -> ())?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    Image("start-watch")
                        .padding(30)
                    VStack(spacing: 18) {
                        
                        Text("Слідкуйте за станом\nздоров’я легко та зручно!")
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .multilineTextAlignment(.center)
                        
                        Text("Щоб розпочати слідкувати за даними показників, під’єднайте годинник або замовте misu Watch")
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 5)
                        
                        Button {
                            KeyStore.saveValue(true, for: .didShowWatchStart)
                            mode.wrappedValue.dismiss()
                            didTapConnect?()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color(Style.TextColors.mainRed))
                                    .frame(height: 50)
                                Text("Під’єднати годинник")
                                    .foregroundColor(.white)
                                    .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                            }
                        }

                        Button {
                            guard let url = URL(string: "https://misu.in.ua/watches/air") else { return }
                            guard UIApplication.shared.canOpenURL(url) else { return }
                            UIApplication.shared.open(url)
                        } label: {
                            
                            Text("Отримати MISU Watch")
                                .foregroundColor(Color(Style.TextColors.mainRed))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                            
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 36, trailing: 16))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .circular)
                        .stroke(Color.blue, lineWidth: 0.7)
                        .frame(width: UIScreen.main.bounds.width - 32)
                )
                .background(Color(red: 0.95, green: 0.97, blue: 1).cornerRadius(14))
                .padding()
            }
            .navigationBarHidden(true)
            .offset(x: 0, y: -40)
        }
        .ignoresSafeArea()
        .background(Color(red: 0.98, green: 0.98, blue: 1))
        .onAppear {
            KeyStore.saveValue(true, for: .didShowChatStart)
        }
    }
}

protocol WatchMainWelcomeDelegate: AnyObject {
    func didDismiss(_ cotroller: WatchMainWelcomeHostingController!, shouldPresentConnection: Bool)
}

final class WatchMainWelcomeHostingController: UIHostingController<WatchMainWelcomePage> {
    
    weak var delegate: WatchMainWelcomeDelegate!
    
    override init(rootView: WatchMainWelcomePage) {
        super.init(rootView: rootView)
        self.rootView.didTapConnect = { [weak self] in
            KeyStore.saveValue(true, for: .didConnectWatchOnce)
            self?.delegate?.didDismiss(self, shouldPresentConnection: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
