//
//  MenuPartnersView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 29.08.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct MenuPartnersView: View {
    
    var onLookTapped: (() -> ())?
    
    var body: some View {
        ZStack {
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(locStr("Partners of MISU"))
                        .font(CustomFonts.createInter(weight: .bold, size: 22))
                        .foregroundColor(Color.white)
                    
                    Text(locStr("Those we trust"))
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                        .foregroundColor(Color.white)
                    Color.clear
                        .frame(height: 1)
                    Button {
                        onLookTapped?()
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.white)
                            Text(locStr("See"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                .foregroundColor(Color(red: 0.32, green: 0.5, blue: 0.97))
                                .padding(8)
                        }
                        .frame(width: 120)
                    }

                }
                Spacer()
                Image("MISUPartnersbag")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
            }
            .padding(16)
        }
        .background(
            LinearGradient(
                colors: [.init(red: 0.5, green: 0.64, blue: 1), .init(red: 0.31, green: 0.5, blue: 0.97)],
                startPoint: .init(x: 0, y: 0),
                endPoint: .init(x: 1, y: 1)
            )
        )
        .cornerRadius(12)
        .padding(16)
        
    }
}
