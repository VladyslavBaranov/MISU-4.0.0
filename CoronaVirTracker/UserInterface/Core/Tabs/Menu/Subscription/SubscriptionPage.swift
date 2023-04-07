//
//  SubscriptionPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 10.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct SubscriptionPage: View {
    
    let helper = StoreHelper()
    
    @State var currentPage = 0
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack {
            
            ZStack {
                HStack {
                    Spacer()
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.black)
                            .font(.system(size: 24, weight: .light))
                    }
                }
                Text("Турбота про сімʼю")
                    .foregroundColor(.black)
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
            }
            .padding(EdgeInsets(top: 25, leading: 20, bottom: 0, trailing: 20))
            
            Spacer()
            
            TabView(selection: $currentPage) {
                ForEach(SubscriptionFeature.createFeatures(), id: \.image) { feature in
                    SubsriptionFeatureView(feature: feature)
                        .padding([.trailing, .leading], 16)
                        .tag(feature.tag)
                }
            }
            .frame(height: UIScreen.main.bounds.width * 0.8)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            /*
            ConfigurableTabView(config: .init(margin: 16, spacing: 16), page: $currentPage) {
                ForEach(SubscriptionFeature.createFeatures(), id: \.image) { feature in
                    SubsriptionFeatureView(feature: feature)
                }
            }
            .frame(height: UIScreen.main.bounds.width * 0.8)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
*/
            PageControl(pageCount: 8, page: $currentPage)
            
            Spacer()
            VStack(spacing: 8) {
                Color(red: 0.89, green: 0.94, blue: 1)
                    .frame(height: 0.5)
                    .padding(.bottom, 4)
                
                Button {
                    
                } label: {
                    VStack {
                        Text("$4.99 / Місяць")
                            .font(CustomFonts.createInter(weight: .medium, size: 15))
                            .foregroundColor(.white)
                        Text("Перший місяць в подарунок")
                            .font(CustomFonts.createInter(weight: .regular, size: 12))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
                    )
                }
                
                Button {
                    
                } label: {
                    VStack {
                        Text("$4.99 / Місяць")
                            .font(CustomFonts.createInter(weight: .medium, size: 15))
                        Text("Економія -15% (Було $60)")
                            .font(CustomFonts.createInter(weight: .regular, size: 12))
                    }
                    .foregroundColor(Color(red: 1, green: 0.369, blue: 0.369))
                    .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                    .background(
                        Capsule(style: .circular)
                            .stroke(Color(red: 1, green: 0.369, blue: 0.369), lineWidth: 1)
                    )
                }
                
                Color.white
                    .frame(height: 40)
            }.background(Color.white)
        }
        .ignoresSafeArea()
        .onAppear {
            
        }
    }
}
