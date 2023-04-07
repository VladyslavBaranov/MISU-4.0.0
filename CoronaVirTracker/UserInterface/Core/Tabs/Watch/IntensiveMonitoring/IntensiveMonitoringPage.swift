//
//  IntensiveMonitoringPage.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 12.07.2022.
//

import SwiftUI

struct IntensiveMonitoringPage: View {
    
    var didTapCancel: (() -> ())?
    var shouldPushDuration: (() -> ())?
    
    @State var durationIsPushed = false
    
    var body: some View {
        GeometryReader { proxy in
            
            NavigationLink(isActive: $durationIsPushed) {
                IntensiveMonitoringIntervalPage()
            } label: {
                EmptyView()
            }

            ZStack {
                Color(red: 0.98, green: 0.99, blue: 1)
                ScrollView {
                    ZStack {
                        HStack {
                            Spacer()
                            Button {
                                didTapCancel?()
                            } label: {
                                Text(locStr("wc_str_4"))
                                    .foregroundColor(Color(Style.TextColors.mainRed))
                                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                            }
                        }
                        Text(locStr("im_str_1"))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                            .foregroundColor(Color(Style.TextColors.commonText))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }
                    .padding()
                    ZStack {
                        VStack(spacing: 40) {
                            Image("Monitoring")
                                .scaledToFit()
                            VStack(spacing: 20) {
                                Text(locStr("im_str_2"))
                                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                                    .bold()
                                    .multilineTextAlignment(.center)
                                Text(locStr("im_str_3"))
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
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(locStr("im_str_4"))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 14))
                        Text(locStr("im_str_5"))
                            .font(CustomFonts.createInter(weight: .regular, size: 14))
                        Text(locStr("im_str_6"))
                            .font(CustomFonts.createInter(weight: .regular, size: 14))
                    }
                    .foregroundColor(Color(Style.TextColors.gray))
                    .padding([.leading, .trailing], 16)
                    
                    Color.clear
                        .frame(height: 100)
                }
                .navigationBarBackButtonHidden(true)
                
                VStack {
                    Spacer()
                    VStack {
                        Button {
                            shouldPushDuration?()
                        } label: {
                            Text(locStr("get_str_6"))
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

final class IntensiveMonitoringController: UIHostingController<IntensiveMonitoringPage> {
    override init(rootView: IntensiveMonitoringPage) {
        super.init(rootView: rootView)
        self.rootView.didTapCancel = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
        self.rootView.shouldPushDuration = { [weak self] in
            let vc = IntensiveMonitoringIntervalController(rootView: .init())
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
