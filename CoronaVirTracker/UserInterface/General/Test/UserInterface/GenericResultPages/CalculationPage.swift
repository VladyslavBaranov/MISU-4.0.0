//
//  CalculationPage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 23.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct CalculationPage: View {
	
	let model: CalculationPageHostingController.Model
	
	@State private var proceduralPercent: Int = 0
	
	var didCalculate: (() -> ())?
	
	var body: some View {
		VStack(spacing: 0) {
			VStack {
				Image(model.imageName)
					.padding(30)
				VStack(spacing: 18) {
					HStack {
						Text(model.title)
						Spacer()
						Text("\(proceduralPercent)%")
					}
					.font(CustomFonts.createInter(weight: .bold, size: 16))
					.foregroundColor(Color(Style.TextColors.commonText))
					
					ProggressView(proggress: $proceduralPercent)
						.frame(height: 16)
					
				}
				.padding(EdgeInsets(top: 0, leading: 16, bottom: 36, trailing: 16))
			}
			.background(Color(red: 0.95, green: 0.97, blue: 1))
			.overlay(
				RoundedRectangle(cornerRadius: 14, style: .circular)
					.stroke(Color.blue, lineWidth: 0.6)
			)
			.padding()
		}
		.navigationBarHidden(true)
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
				proceduralPercent = 50
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
				proceduralPercent = 100
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
				didCalculate?()
			}
			
		}
	}
}

protocol CalculationPageDelegate: AnyObject {
	func didCalculate()
}

class CalculationPageHostingController: UIHostingController<CalculationPage> {
	
	weak var delegate: CalculationPageDelegate!
	
	struct Model {
		let imageName: String
		let title: String
	}
	
	override init(rootView: CalculationPage) {
		super.init(rootView: rootView)
		self.rootView.didCalculate = { [weak self] in
			self?.delegate.didCalculate()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static func createInstance(_ model: CalculationPageHostingController.Model) -> CalculationPageHostingController {
		let controller = CalculationPageHostingController(rootView: .init(model: model))
		return controller
	}
}

