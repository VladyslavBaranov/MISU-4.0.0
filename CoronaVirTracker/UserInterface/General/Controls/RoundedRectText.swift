//
//  RoundedRectText.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 23.06.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct RoundedRectText: View {
    
    @Binding var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .circular)
                .stroke(Color(white: 0.8), lineWidth: 0.3)
                .background(Color.clear)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            HStack {
                Text(text)
                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            HStack {
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .padding(.trailing, 10)
                
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct RoundedRectTextContainer: View {
    
    var title: String
    var text: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .font(CustomFonts.createInter(weight: .regular, size: 14))
                .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .stroke(Color(white: 0.8), lineWidth: 0.3)
                    .background(Color(red: 0.97, green: 0.98, blue: 1))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                HStack {
                    Text(text)
                        .font(CustomFonts.createInter(weight: .regular, size: 15))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
            .frame(maxWidth: .infinity)
        }
    }
}
