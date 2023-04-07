//
//  HeartrateCharacteristicPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 18.08.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI
// import Charts

struct HeartrateCharacteristicPage: View {
    
    @Environment(\.presentationMode) var mode
    
    var cards: [IllnessData.Card]
    
    init() {
        let loader = HealthStateDescriptionLoader(illness: "Heartrate")
        if let cards = loader.illnessData?.cards {
            self.cards = cards
        } else {
            self.cards = []
        }
    }
    
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
                Text(locStr("hc_str_6"))
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(Style.TextColors.commonText))
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            ScrollView {
                
                ZStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Group {
                            Text(locStr("gen_str_5"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                .foregroundColor(Color(Style.TextColors.gray))
                            Text("120/80")
                                .font(CustomFonts.createInter(weight: .bold, size: 22))
                                .foregroundColor(Color(Style.TextColors.commonText))
                            // GraphView()
                                //.frame(maxWidth: .infinity)
                                //.frame(height: 300)
                            //Image("Graph")
                                //.resizable()
                                //.scaledToFit()
                                .padding([.top, .bottom], 10)
                        }
                    }.padding(16)
                }
                
                VStack(alignment: .leading) {
                    
                    ForEach(0..<cards.count, id: \.self) { i in
                        VStack(alignment: .leading) {
                            Text(locStr(cards[i].title))
                                .font(CustomFonts.createInter(weight: .bold, size: 22))
                            HealthStateCardView(card: cards[i])
                            
                        }
                        .padding()
                    }
                    
                }
                .background(Color(red: 0.98, green: 0.99, blue: 1))
                Color.clear
                    .frame(height: 110)
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

