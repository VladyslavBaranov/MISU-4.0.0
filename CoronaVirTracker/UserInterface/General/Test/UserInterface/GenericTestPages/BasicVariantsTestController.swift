//
//  BasicVariantsTestController.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 22.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI
 
struct BasicVariantsTestPage: View {
	
	var model: BasicVariantsTestController.Model
	
	var backButtonTapped: (() -> ())?
	var onNext: (() -> ())?
	var onCancel: (() -> ())?
	
	private let columns: [GridItem] = [
		GridItem(.flexible()), GridItem(.flexible())
	]
	
	@State var isLoading = false
	
	@State var selectedIndex = 0
	
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Color(red: 0.98, green: 0.98, blue: 1)
					.frame(height: 30)
				ZStack {
					HStack {
						Button {
							backButtonTapped?()
						} label: {
							Image("orange_back")
								.font(.system(size: 24))
						}
						Spacer()
						Button {
							onCancel?()
						} label: {
							Text("Скасувати")
								.font(CustomFonts.createInter(weight: .regular, size: 15))
								.foregroundColor(Color(Style.TextColors.mainRed))
						}
					}
					Text(model.testName)
						.font(CustomFonts.createInter(weight: .semiBold, size: 16))
						.multilineTextAlignment(.center)
						
				}
				.padding([.leading, .trailing], 16)
				.foregroundColor(.black)
				
				Color.clear
					.frame(height: 30)
				
				VStack(alignment: .center, spacing: 10) {
					
					Text("Питання \(model.questionIndex) з \(model.testQuestionCount)")
						.font(CustomFonts.createInter(weight: .medium, size: 18))
						.foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
					
					Text(model.statement)
						.font(CustomFonts.createInter(weight: .medium, size: 18))
						.multilineTextAlignment(.center)
					
					LazyVGrid(columns: columns, spacing: 11) {
						ForEach(0..<model.variants.count, id: \.self) { index in
							ZStack {
								RoundedRectangle(cornerRadius: 12)
									.stroke(
										selectedIndex == index ? Color(red: 0.36, green: 0.61, blue: 0.97) : Color(Style.Stroke.lightGray),
										lineWidth: 1
									)
									.background(Color.white.cornerRadius(12))
								VStack {
									HStack {
										Text(model.variants[index])
											.font(CustomFonts.createInter(weight: .regular, size: 15))
											.foregroundColor(
												selectedIndex == index ? Color(red: 0.36, green: 0.61, blue: 0.97) : Color(Style.TextColors.commonText)
											)
										Spacer()
									}
									Spacer()
								}
								.padding(16)
							}
							.frame(height: 130)
							.onTapGesture {
								selectedIndex = index
							}
						}
					}
					.padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
					Text(model.subtitle)
						.font(CustomFonts.createInter(weight: .regular, size: 14))
						.foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
						.padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12))
				}
				
				Spacer()
			}
			.ignoresSafeArea()
			.background(Color(red: 0.98, green: 0.98, blue: 1))
			.navigationBarHidden(true)
			
            AppRedButtonTabView(title: "Далі") {
				onNext?()
			}
			
			if isLoading {
				ZStack {
					BlurView()
						.frame(width: 90, height: 90)
						.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
					ProgressView()
						.progressViewStyle(.circular)
				}
			}
		}
	}
}

final class BasicVariantsTestController: UIHostingController<BasicVariantsTestPage>, TestControllerProtocol {
	
	weak var delegate: TestControllerDelegate!
	
	weak var test: Test!
	
	struct Model {
		let testName: String
		let questionIndex: Int
		let testQuestionCount: Int
		let statement: String
		let variants: [String]
		let subtitle: String
	}
	
	override init(rootView: BasicVariantsTestPage) {
		super.init(rootView: rootView)
		self.rootView.onNext = { [weak self] in
			guard let strongSelf = self else { return }
			let variant = strongSelf.rootView.model.variants[strongSelf.rootView.selectedIndex]
			strongSelf.delegate.didAnswerWithString(
				variant,
				vIndex: strongSelf.rootView.selectedIndex,
				qIndex: strongSelf.rootView.model.questionIndex
			)
			strongSelf.test.moveNext()
		}
		self.rootView.backButtonTapped = { [weak self] in
			self?.navigationController?.popViewController(animated: true)
			self?.test.moveBack()
		}
		self.rootView.onCancel = { [weak self] in
			self?.navigationController?.dismiss(animated: true)
		}
	}
	
	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
	}
	
	static func createInstance(_ model: Model) -> BasicVariantsTestController {
		let vc = BasicVariantsTestController(rootView: .init(model: model))
		return vc
	}
}
