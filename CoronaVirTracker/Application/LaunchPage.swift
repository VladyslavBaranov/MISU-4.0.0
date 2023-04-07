//
//  LaunchPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 11.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct LaunchPage: View {
    
    var onFinish: (() -> ())?
    
    @State var misuOpacity: CGFloat = 0.0
    @State var titleOpacity: CGFloat = 0.0
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Image("LaunchLogo")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .shadow(
                        color: Color(red: 1, green: 0.44, blue: 0.44, opacity: 0.25),
                        radius: 40
                    )
                Text("MISU")
                    .font(CustomFonts.createInter(weight: .regular, size: 77))
                    .opacity(misuOpacity)
                Text("Chance to live long")
                    .font(CustomFonts.createInter(weight: .regular, size: 20))
                    .opacity(titleOpacity)
            }
            .foregroundColor(Color(red: 0.11, green: 0.23, blue: 0.38))
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                withAnimation {
                    misuOpacity = 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                withAnimation {
                    titleOpacity = 1
                }
            }
        }
    }
}
