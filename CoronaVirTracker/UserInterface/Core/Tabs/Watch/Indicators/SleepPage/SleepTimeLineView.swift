//
//  SleepTimeLineView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 20.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct SleepPhaseItem {
    let icon: String
    var durationString: String
    let title: String
}

struct SleepInfoItem {
    let icon: String
    var info: String
    var normInfo: String?
    var value: String = ""
}

struct SleepPhaseView: View {
    
    let phase: SleepPhaseItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(phase.icon)
                .resizable()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 5) {
                Text(phase.durationString)
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                Text(phase.title)
                    .font(CustomFonts.createInter(weight: .regular, size: 15))
                    .foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
            }
            Spacer()
        }
    }
}

struct SleepInfoView: View {
    
    let info: SleepInfoItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(info.icon)
                .resizable()
                .frame(width: 48, height: 48)
            VStack(alignment: .leading, spacing: 5) {
                Text(info.info)
                    .font(CustomFonts.createInter(weight: .regular, size: 16)) +
                Text(" \(info.value)")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                if info.normInfo != nil {
                    Text(info.normInfo!)
                        .font(CustomFonts.createInter(weight: .regular, size: 15))
                        .foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
                }
                
            }
            Spacer()
        }
    }
}

struct SleepTimeLineView: View {
    
    @Binding var dateString: String
    var onBack: (() -> ())
    var onForward: (() -> ())
    
    var body: some View {
        HStack {
            Button {
                onBack()
            } label: {
                Image(systemName: "chevron.left")
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.38, green: 0.65, blue: 1), Color(red: 0.31, green: 0.49, blue: 0.95)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 40)
                Text(dateString)
                    .font(CustomFonts.createInter(weight: .semiBold, size: 14.5))
                    .foregroundColor(.white)
            }
            
            Button {
                onForward()
            } label: {
                Image(systemName: "chevron.right")
            }
        }
    }
}
