//
//  IndicatorsTimeLineView.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 02.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct IndicatorsTimeLineView: View {
	
	@Binding var selectedOptionIndex: Int
	
	@State private var gradientXOffset: CGFloat = 0.0
	
	var body: some View {
		GeometryReader { proxy in
			
			RoundedRectangle(cornerRadius: 18, style: .continuous)
				.fill(
					LinearGradient(
						colors: [
							Color(red: 0.38, green: 0.65, blue: 1), Color(red: 0.31, green: 0.49, blue: 0.95)
						], startPoint: .topLeading, endPoint: .bottomTrailing
					)
				)
				.frame(width: proxy.frame(in: .local).width / 4 - 4)
				.padding(2)
				.offset(x: gradientXOffset, y: 0)
			
			ZStack {
				RoundedRectangle(cornerRadius: 20, style: .continuous)
					.stroke(Color(red: 0.89, green: 0.94, blue: 1), lineWidth: 1)
				
				HStack(spacing: 0) {
					Button {
						selectedOptionIndex = 0
						moveGradientToSector(0, proxy: proxy)
					} label: {
						Text(locStr("datetime_day"))
							.frame(width: proxy.frame(in: .local).width / 4)
							.foregroundColor(
								selectedOptionIndex == 0 ? .white : Color(red: 0.41, green: 0.47, blue: 0.6)
							)
					}
					Color(red: 0.89, green: 0.94, blue: 1)
						.frame(width: 1, height: 20)
						.opacity(selectedOptionIndex == 0 || selectedOptionIndex == 1 ? 0 : 1)
					Button {
						selectedOptionIndex = 1
						moveGradientToSector(1, proxy: proxy)
					} label: {
						Text(locStr("datetime_week"))
							.frame(width: proxy.frame(in: .local).width / 4)
							.foregroundColor(
								selectedOptionIndex == 1 ? .white : Color(red: 0.41, green: 0.47, blue: 0.6)
							)
					}
					Color(red: 0.89, green: 0.94, blue: 1)
						.frame(width: 1, height: 20)
						.opacity(selectedOptionIndex == 1 || selectedOptionIndex == 2 ? 0 : 1)
					Button {
						selectedOptionIndex = 2
						moveGradientToSector(2, proxy: proxy)
					} label: {
						Text(locStr("datetime_month"))
							.frame(width: proxy.frame(in: .local).width / 4)
							.foregroundColor(
								selectedOptionIndex == 2 ? .white : Color(red: 0.41, green: 0.47, blue: 0.6)
							)
					}
					Color(red: 0.89, green: 0.94, blue: 1)
						.frame(width: 1, height: 20)
						.opacity(selectedOptionIndex == 2 || selectedOptionIndex == 3 ? 0 : 1)
					Button {
						selectedOptionIndex = 3
						moveGradientToSector(3, proxy: proxy)
					} label: {
						Text(locStr("datetime_year"))
							.frame(width: proxy.frame(in: .local).width / 4)
							.foregroundColor(
								selectedOptionIndex == 3 ? .white : Color(red: 0.41, green: 0.47, blue: 0.6)
							)
					}
				}
				.font(CustomFonts.createInter(weight: .regular, size: 12))
			}
		}
	}
	
	func moveGradientToSector(_ sector: Int, proxy: GeometryProxy) {
		let sectorW = (proxy.frame(in: .local).width + 4) / 4
		withAnimation {
			gradientXOffset = sectorW * CGFloat(sector)
		}
	}
}
