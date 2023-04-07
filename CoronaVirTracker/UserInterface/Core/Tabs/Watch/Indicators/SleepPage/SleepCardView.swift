//
//  SleepCardView.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 28.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct SleepCardItem {
	let index: Int
	let gradient: [Color]
	let title: String
	let icon: String
	
	static func getItems() -> [SleepCardItem] {
		[
			.init(
				index: 0,
				gradient: [Color(red: 0.38, green: 0.65, blue: 1), Color(red: 0.31, green: 0.49, blue: 0.95)],
				title: "Рекомендований\nграфік сну",
				icon: "sleep-recommended"
			),
			.init(
				index: 1,
				gradient: [Color(red: 0.56, green: 0.61, blue: 1), Color(red: 0.43, green: 0.48, blue: 1)],
				title: "Лягаєте спати занадто\nпізно або рано",
				icon: "sleep-time"
			),
			.init(
				index: 2,
				gradient: [Color(red: 0.46, green: 0.45, blue: 1), Color(red: 0.26, green: 0.25, blue: 0.83)],
				title: "Більше снів!",
				icon: "sleep-more"
			),
			.init(
				index: 3,
				gradient: [Color(red: 0.34, green: 0.48, blue: 0.97), Color(red: 0.19, green: 0.35, blue: 0.93)],
				title: "Відчуваєте себе невиспаними\nпісля сну?",
				icon: "sleep-unsleep"
			)
		]
	}
}

struct SleepCardView: View {
	
	let item: SleepCardItem
	let onRead: () -> ()

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 12, style: .continuous)
				.fill(
					LinearGradient(
						colors: item.gradient,
						startPoint: UnitPoint(x: 0, y: 0),
						endPoint: UnitPoint(x: 1, y: 1)
					)
				)
			HStack {
				VStack(alignment: .leading) {
					Text(item.title)
						.foregroundColor(.white)
						.font(CustomFonts.createInter(weight: .medium, size: 18))
					
					Button {
						onRead()
					} label: {
						ZStack {
							RoundedRectangle(cornerRadius: 20, style: .continuous)
								.fill(Color.white)
								.frame(width: 100, height: 40)
							Text("Читати")
								.font(CustomFonts.createInter(weight: .semiBold, size: 15))
						}
					}
				}
				Spacer()
				VStack {
					Spacer()
					Image(item.icon)
						.resizable()
						.scaledToFit()
						.frame(width: 70, height: 70)
				}
			}
			.padding(16)
		}
	}
}
