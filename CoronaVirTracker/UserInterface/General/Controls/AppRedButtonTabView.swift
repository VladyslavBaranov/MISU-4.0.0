//
//  AppRedButtonTabView.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 24.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct AppRedButtonTabView: View {
	
    let title: String
	
	let onTapped: (() -> ())
	
	var body: some View {
		VStack {
			Spacer()
            VStack(spacing: 0) {
                Color(red: 0.89, green: 0.94, blue: 1)
                    .frame(height: 0.5)
				Button {
					onTapped()
				} label: {
					Text(title)
						.font(CustomFonts.createInter(weight: .semiBold, size: 15))
						.foregroundColor(.white)
						.frame(width: UIScreen.main.bounds.width - 32, height: 54)
						.background(
							Capsule(style: .circular)
								.fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
						)
				}
				.frame(width: UIScreen.main.bounds.width, height: 100)
				
				Color.white
					.frame(height: 30)
			}.background(Color.white)
		}
		.ignoresSafeArea()
	}
	
}

struct AppRedButtonTabProgressView: View {
    
    let title: String
    @Binding var isRunningAction: Bool
    
    let onTapped: (() -> ())
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Color(red: 0.89, green: 0.94, blue: 1)
                    .frame(height: 0.5)
                if isRunningAction {
                    ZStack {
                        Capsule(style: .circular)
                            .fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
                            .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                } else {
                    Button {
                        onTapped()
                    } label: {
                        Text(title)
                            .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 54)
                            .background(
                                Capsule(style: .circular)
                                    .fill(Color(UIColor(red: 1, green: 0.369, blue: 0.369, alpha: 1)))
                            )
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                }
                
                Color.white
                    .frame(height: 30)
            }.background(Color.white)
        }
        .ignoresSafeArea()
    }
    
}
