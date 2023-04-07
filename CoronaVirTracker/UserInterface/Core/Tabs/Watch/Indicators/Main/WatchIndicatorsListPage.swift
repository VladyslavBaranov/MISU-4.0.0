//
//  WatchIndicatorsListPage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 26.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

fileprivate struct Item {
	let iconName: String
	let title: String
}

struct WatchIndicatorsListCell: View {
	
	fileprivate let item: __HealthIndicatorType
	
	var body: some View {
		HStack(spacing: 12) {
			Image(item.iconName())
				.resizable()
				.frame(width: 50, height: 50)
			Text(item.stringValue())
				.font(CustomFonts.createInter(weight: .semiBold, size: 16))
				.foregroundColor(Color(Style.TextColors.commonText))
			Spacer()
			Image("common_chevron")
		}
		.frame(height: 60)
	}
}

struct WatchIndicatorsListPage: View {
	
	@Environment(\.presentationMode) var mode
	
	private let items: [__HealthIndicatorType] = [
		.sleep, // .activity,
        .pressure, .heartrate,
        // .ecg,
        .sugar, .insuline, .oxygen, .temperature
	]
	
	var onIndicatorTapped: ((__HealthIndicatorType) -> ())?
	
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
				Text(locStr("hc_str_1"))
					.font(CustomFonts.createInter(weight: .semiBold, size: 16))
					.multilineTextAlignment(.center)
					.foregroundColor(Color(Style.TextColors.commonText))
			}
			.padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
			.background(Color.white)
			.foregroundColor(.black)
			
			ScrollView {
				Color.clear
					.frame(height: 15)
				ForEach(0..<items.count, id: \.self) { index in
					WatchIndicatorsListCell(item: items[index])
						.padding([.leading, .trailing], 16)
                        .contentShape(Rectangle())
						.onTapGesture {
							onIndicatorTapped?(items[index])
						}
					if index < items.count - 1 {
						Color(red: 0.89, green: 0.94, blue: 1)
							.frame(height: 1)
							.padding([.leading, .trailing], 16)
					}
				}
				Color.clear
					.frame(height: 80)
			}
			.background(Color(red: 0.98, green: 0.98, blue: 1))
		}
		.navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .top)
	}

}

final class WatchIndicatorsListHostingController: UIHostingController<WatchIndicatorsListPage> {
	
	override init(rootView: WatchIndicatorsListPage) {
		super.init(rootView: rootView)
		self.rootView.onIndicatorTapped = { [weak self] indicator in
			self?.pushIdicatorController(indicator)
		}
	}
	
	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func pushIdicatorController(_ indicator: __HealthIndicatorType) {
		
		var loaderName: String = ""
		switch indicator {
		case .sleep:
			let vc = SleepIndicatorHostingController(rootView: .init())
			navigationController?.pushViewController(vc, animated: true)
			return
        case .activity:
            let vc = ActivityHostingController(rootView: .init())
            navigationController?.pushViewController(vc, animated: true)
            return
		case .pressure:
			loaderName = "BloodPressure"
		case .heartrate:
			loaderName = "Heartrate"
		case .temperature:
			loaderName = "Temperature"
		case .oxygen:
			loaderName = "Oxygen"
		case .sugar:
			loaderName = "Sugar"
		case .insuline:
			loaderName = "Insuline"
		default:
			break
		}
		let vc = GenericIndicatorHostingController.createInstance(loaderName: loaderName, indicator: indicator)
		navigationController?.pushViewController(vc, animated: true)
	}
}
