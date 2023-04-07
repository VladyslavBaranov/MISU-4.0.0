//
//  ScalarResultPage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 23.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct ScalarResultPage: View {
	
	let model: ScalarResultPageHostingController.Model
	
	var onNext: (() -> ())?
	
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				VStack {
					Image(model.imageName)
						.padding(30)
					VStack(spacing: 18) {
						
						Text(model.title)
							.font(CustomFonts.createInter(weight: .semiBold, size: 16))
							.foregroundColor(Color(Style.TextColors.commonText))
						
						Text(formattedNumber(model.number))
							.font(CustomFonts.createInter(weight: .bold, size: 36))
							.foregroundColor(Color(Style.TextColors.commonText))
						
					}
					.padding(EdgeInsets(top: 0, leading: 16, bottom: 36, trailing: 16))
				}
				.overlay(
					RoundedRectangle(cornerRadius: 14, style: .circular)
						.stroke(Color.blue, lineWidth: 0.6)
						.frame(width: UIScreen.main.bounds.width - 32)
					// .background(Color(red: 0.95, green: 0.97, blue: 1).cornerRadius(14))
				)
				.padding()
				
				HStack {
					VStack(alignment: .leading, spacing: 10) {
						Text(model.bmiResult.title)
							.font(CustomFonts.createInter(weight: .semiBold, size: 14))
							.foregroundColor(
								model.bmiResult.state == .normal ? Color(red: 0.15, green: 0.76, blue: 0.61) : Color(Style.TextColors.mainRed)
							)
						Text(model.bmiResult.survey)
							.font(CustomFonts.createInter(weight: .regular, size: 14))
							.foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
					}
					Spacer()
				}
				.frame(width: UIScreen.main.bounds.width - 32)
			}
			.navigationBarHidden(true)
			.offset(x: 0, y: -40)
			
            AppRedButtonTabView(title: "Далі") {
				onNext?()
			}
		}
		.ignoresSafeArea()
		.background(Color(red: 0.98, green: 0.98, blue: 1))
	}
	
	
	func formattedNumber(_ number: Double) -> String {
		let formatter = NumberFormatter()
		formatter.decimalSeparator = "."
		formatter.maximumFractionDigits = 1
		return formatter.string(from: .init(floatLiteral: number)) ?? "0"
	}
}

class ScalarResultPageHostingController: UIHostingController<ScalarResultPage> {
	
	weak var test: Test!
	
	struct Model {
		let imageName: String
		let title: String
		let number: Double
		let bmiResult: BMIResult
	}
	
	override init(rootView: ScalarResultPage) {
		super.init(rootView: rootView)
		self.rootView.onNext = { [weak self] in
			self?.test.moveNext()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
	}
	
	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static func createInstance(_ model: ScalarResultPageHostingController.Model) -> ScalarResultPageHostingController {
		let controller = ScalarResultPageHostingController(rootView: .init(model: model))
		return controller
	}
}


