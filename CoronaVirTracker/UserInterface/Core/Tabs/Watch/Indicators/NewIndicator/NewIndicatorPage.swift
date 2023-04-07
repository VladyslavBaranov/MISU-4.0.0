//
//  NewIndicatorPage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 02.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct NewIndicatorPage: View {
	
	let indicator: __HealthIndicatorType
	
	@State var value: String = ""
	@State var additionalValue: String = ""
	
	@Environment(\.presentationMode) var mode
	
	var body: some View {
		VStack(spacing: 0) {
			ZStack {
				HStack {
					Button {
						mode.wrappedValue.dismiss()
					} label: {
						Text(locStr("wc_str_4"))
							.font(CustomFonts.createInter(weight: .regular, size: 15))
							.foregroundColor(Color(Style.TextColors.mainRed))
					}
					Spacer()
					Button {
                        
                        let _indicator = _HealthIndicator()
                        _indicator.type = indicator
                        _indicator.date = Date()
                        _indicator.value = Double(value) ?? 0.0
                        if !additionalValue.isEmpty {
                            _indicator.additionalValue = Double(additionalValue) ?? 0.0
                        }
                        RealmIndicator.insert(_indicator)
                        
                        NotificationManager.shared.post(.didUpdateIndicator, object: indicator)
                        
                        mode.wrappedValue.dismiss()
                        
					} label: {
						Text(locStr("gui_add"))
							.font(CustomFonts.createInter(weight: .semiBold, size: 15))
							.foregroundColor(Color(Style.TextColors.mainRed))
							.opacity(isValidValue() ? 1 : 0.5)
					}
					.disabled(!isValidValue())
				}
				Text(indicator.stringValue())
					.font(CustomFonts.createInter(weight: .semiBold, size: 16))
					.multilineTextAlignment(.center)
					.foregroundColor(Color(Style.TextColors.commonText))
			}
			.padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
			.foregroundColor(.black)
			
			Color.clear
				.frame(height: 20)
			
			ScrollView {
				ZStack {
					RoundedRectangle(cornerRadius: 12, style: .continuous)
						.stroke(Color(red: 0.89, green: 0.94, blue: 1), lineWidth: 1)
					VStack(spacing: 20) {
						HStack {
							Text(locStr("datetime_date"))
								.font(CustomFonts.createInter(weight: .regular, size: 15))
								.foregroundColor(Color(Style.TextColors.gray))
							Spacer()
							Text(getDateString())
								.font(CustomFonts.createInter(weight: .regular, size: 16))
						}
						Color(red: 0.89, green: 0.94, blue: 1)
							.frame(height: 0.5)
						HStack {
							Text(locStr("datetime_time"))
								.font(CustomFonts.createInter(weight: .regular, size: 15))
								.foregroundColor(Color(Style.TextColors.gray))
							Spacer()
							Text(getTimeString())
								.font(CustomFonts.createInter(weight: .regular, size: 16))
						}
						Color(red: 0.89, green: 0.94, blue: 1)
							.frame(height: 0.5)
						if indicator == .pressure {
							HStack {
								Text("Систолічний")
									.font(CustomFonts.createInter(weight: .regular, size: 15))
									.foregroundColor(Color(Style.TextColors.gray))
								TextField("", text: $value)
									.multilineTextAlignment(.trailing)
									.font(CustomFonts.createInter(weight: .regular, size: 16))
									.keyboardType(.phonePad)
							}
							Color(red: 0.89, green: 0.94, blue: 1)
								.frame(height: 0.5)
							HStack {
								Text("Діастолічний")
									.font(CustomFonts.createInter(weight: .regular, size: 15))
									.foregroundColor(Color(Style.TextColors.gray))
								TextField("", text: $additionalValue)
									.multilineTextAlignment(.trailing)
									.font(CustomFonts.createInter(weight: .regular, size: 16))
									.keyboardType(.phonePad)
							}
						} else {
							HStack {
								Text(indicator.unitString())
									.font(CustomFonts.createInter(weight: .regular, size: 15))
									.foregroundColor(Color(Style.TextColors.gray))
								TextField("", text: $value)
									.multilineTextAlignment(.trailing)
									.font(CustomFonts.createInter(weight: .regular, size: 16))
									.keyboardType(.phonePad)
							}
						}
						
					}
					.padding(16)
				}
				.padding(16)
			}
		}
	}
	
	func getDateString() -> String {
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "d MMMM yyyy"
		return formatter.string(from: date)
	}
	func getTimeString() -> String {
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter.string(from: date)
	}
	
	func isValidValue() -> Bool {
		!value.isEmpty && Double(value) != nil
	}
}

final class NewIndicatorHostingController: UIHostingController<NewIndicatorPage> {
	static func createInstance(_ indicator: __HealthIndicatorType) -> UIViewController {
		let vc = NewIndicatorHostingController(rootView: .init(indicator: indicator))
		vc.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
		return vc
	}
}
