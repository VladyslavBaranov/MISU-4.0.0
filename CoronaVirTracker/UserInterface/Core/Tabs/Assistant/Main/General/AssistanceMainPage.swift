//
//  ViewController.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 19.06.2022.

import SwiftUI

struct AssistanceMainPage: View {
    
    @State var unreadCount = RealmMessage.getUnreadMessagesCount()
    
    @ObservedObject var state = AssistanceMainPageState()
    
    @State private var verticalOffset: CGFloat = 0.0
    
    @State var scaleDownFactor: CGFloat = 0.0
    
    var onDoctorLinkTapped: (() -> ())?
    
    var onRiskGroupTapped: (() -> ())?
    
    var onHowItWorksTapped: (() -> ())?
    
    var onChatTapped: (() -> ())?
    
    var onChatListTapped: (() -> ())?
    
    var onHealthDataLinkTapped: (() -> ())?
    
    var onRegisterTapped: (() -> ())?
    
    var onNotificationsTapped: (() -> ())?
    
    var onChatListIconTapped: (() -> ())?
    
    var body: some View {

        ZStack {
            OffsettableScrollView { point in
                
                verticalOffset = point.y
                if point.y > 0 {
                    verticalOffset = point.y
                } else {
                    let factor = abs(point.y) / (UIScreen.main.bounds.width * 0.5)
                    let finalFactor = factor > 1 ? 1 : factor
                    scaleDownFactor = finalFactor
                }
                
            } content: {
                VStack(alignment: .center) {
                    Color.clear
                        .frame(height: UIScreen.main.bounds.width + 10)
                    
                    /*
                    Group {
                        HStack {
                            Text(locStr("mah_str_6"))
                                .font(CustomFonts.createInter(weight: .bold, size: 22))
                                .foregroundColor(Color(Style.TextColors.commonText))
                            Spacer()
                            HStack {
                                Button {
                                    onHealthDataLinkTapped?()
                                } label: {
                                    Text(locStr("mah_str_7"))
                                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                                        .foregroundColor(Color(Style.TextColors.mainRed))
                                }
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16))
                                    .foregroundColor(.red)
                            }
                            

                        }.padding([.trailing, .leading], 16)
                        
                        // AssistanceHealthDataScrollView()
                    }
                     */
                    
                    // Color.clear
                    //     .frame(height: 30)
                    
                    Group {
                        HStack {
                            Text(locStr("mah_str_13"))
                                .font(CustomFonts.createInter(weight: .bold, size: 22))
                                .foregroundColor(Color(Style.TextColors.commonText))
                            Spacer()
                        }
                        .padding([.trailing, .leading, .bottom], 16)
                        AssistanceMyAssistantView()
                            .onRiskGroupTapped {
                                onRiskGroupTapped?()
                            }
                            .onOnlineDoctorTapped {
                                onDoctorLinkTapped?()
                            }
                    }
                    
                    Group {
                        Color.clear
                            .frame(height: 40)
                        
                        AssistanceHowItWorksCard()
                            .onTapGesture {
                                onHowItWorksTapped?()
                            }
                        Color.clear
                            .frame(height: 40)
                    }
                    
					/*
                    Button {
                        onActivateAssistantTapped?()
                    } label: {
                        VStack {
                            Text("DEVELOPMENT ONLY")
                            Text("Activate Assistant")
                        }
                    }
					 */
                    /*
                    Button {
                        onRegisterTapped?()
                    } label: {
                        VStack {
                            Text("DEVELOPMENT ONLY")
                            Text("Register")
                        }
                    }
                    */
                    Color.clear
                        .frame(height: 30)
                    
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                AssistantHeader(
                    scaledownFactor: $scaleDownFactor,
                    verticalOffset: $verticalOffset) {
                        onChatTapped?()
                    } onNotificationsTapped: {
                        onNotificationsTapped?()
                    }
                Spacer()
            }
            
            VStack {
                Color.clear
                    .frame(height: 30)
                ZStack {
                    Text(locStr("mah_str_5"))
                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                        .opacity(getTitleOpacity())
                    HStack {
                        Spacer()
                        Button {
                            onChatListIconTapped?()
                        } label: {
                            ZStack {
                                Image("Message")
                                if unreadCount != 0 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 12, y: -12)
                                }
                            }
                            .offset(x: 0, y: -2)
                        }
                    }
                    .opacity(getTitleOpacity())
                }
                .padding()
                .foregroundColor(.white)
                Spacer()
            }
            
        }.ignoresSafeArea(.all, edges: .top)
        
    }
    
    private func getTitleOpacity() -> Double {
        guard let country = KeyStore.getStringValue(for: .userCountry) else {
            return 1
        }
        if country == "pl" {
            return 0
        }
        return 1
    }
}
