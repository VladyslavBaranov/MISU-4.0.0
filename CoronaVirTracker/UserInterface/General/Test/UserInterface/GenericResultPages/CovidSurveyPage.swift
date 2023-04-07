//
//  CovidSurveyPage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 25.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct CovidSurveyPage: View {
	
	var onNext: (() -> ())?
	
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				VStack {
					Image("ActivationWoman")
						.padding(30)
					VStack(spacing: 18) {
						
						Text("Дані в порядку,\nВи не в групі ризику!")
							.font(CustomFonts.createInter(weight: .bold, size: 22))
							.foregroundColor(Color(Style.TextColors.commonText))
							.multilineTextAlignment(.center)
						
						Text("Ви не знаходитесь у групі ризику\nCovid-19")
							.font(CustomFonts.createInter(weight: .regular, size: 16))
							.foregroundColor(Color(Style.TextColors.commonText))
							.multilineTextAlignment(.center)
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
						Text("Увага!")
							.font(CustomFonts.createInter(weight: .semiBold, size: 14))
							.foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
						Text("Даний тест на є лікарським заключенням! Для здійснення профілактики та встановлення даігнозу звернітьсся до лікаря!")
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

class CovidSurveyPageHostingController: UIHostingController<CovidSurveyPage> {
	
	override init(rootView: CovidSurveyPage) {
		super.init(rootView: rootView)
		self.rootView.onNext = { [weak self] in
			self?.navigationController?.dismiss(animated: true)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
	}
	
	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static func createInstance() -> UIViewController {
		let controller = CovidSurveyPageHostingController(rootView: .init())
		return controller
	}
}



