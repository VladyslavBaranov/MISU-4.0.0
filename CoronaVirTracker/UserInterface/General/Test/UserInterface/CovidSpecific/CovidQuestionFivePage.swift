//
//  CovidQuestionFivePage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 23.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

fileprivate struct _Variant {
	let title: String
	var isSelected = false
}

final class CovidQuestionFivePageState: ObservableObject {
	
	var selectedIndex = 0
	
	fileprivate var variants: [_Variant] = [
		.init(title: "AstraZeneca", isSelected: true),
		.init(title: "CoronaVac (Sinovac)"),
		.init(title: "Comirnaty (Pfizer)"),
		.init(title: "Moderna"),
		.init(title: "Вакцинації не маю")
	]
	
	func toggle(_ index: Int) {
		for i in 0...4 {
			variants[i].isSelected = index == i
		}
		selectedIndex = index
		objectWillChange.send()
	}
}

struct CovidQuestionFiveVariantView: View {
	
	fileprivate let variant: _Variant
	
	var body: some View {
		HStack {
			Text(variant.title)
				.font(CustomFonts.createInter(weight: .regular, size: 15))
			Spacer()
			Image(variant.isSelected ? "reg_option_sel" : "reg_option")
				.resizable()
				.frame(width: 22, height: 22)
		}
		.padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
	}
}

struct CovidQuestionFivePage: View {
	
	@ObservedObject var state = CovidQuestionFivePageState()
	
	var backButtonTapped: (() -> ())?
	var onNext: (() -> ())?
	var onCancel: (() -> ())?
	
	@ObservedObject var dateField = FormField(validator: .date)
	
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
					Text("Рівень ризику\nCovid-19")
						.font(CustomFonts.createInter(weight: .semiBold, size: 16))
						.multilineTextAlignment(.center)
					
				}
				.padding([.leading, .trailing], 16)
				.foregroundColor(.black)
				
				ScrollView {
					
					Color.clear
						.frame(height: 30)
					
					VStack(alignment: .center, spacing: 10) {
						
						Text("Питання 5 з 6")
							.font(CustomFonts.createInter(weight: .medium, size: 18))
							.foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
						
						Text("Чи маєте ви вакцінацію? Якщо так,\n оберіть вид і введіть дату вакцинації")
							.font(CustomFonts.createInter(weight: .medium, size: 18))
							.multilineTextAlignment(.center)
						
						
						ZStack {
							RoundedRectangle(cornerRadius: 12, style: .continuous)
								.stroke(Color(white: 0.94), lineWidth: 1)
								.background(Color(red: 0.97, green: 0.98, blue: 1))
								.padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
							VStack {
								ForEach(0..<4) { index in
									CovidQuestionFiveVariantView(variant: state.variants[index])
										.onTapGesture {
											state.toggle(index)
										}
									if index != 3 {
										Color(red: 0.89, green: 0.94, blue: 1)
											.frame(height: 1)
											.padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 25))
									}
								}
							}
							.padding(EdgeInsets(top: 32, leading: 16, bottom: 16, trailing: 16))
						}
						
						if state.selectedIndex < 4 {
							TextFieldContainer(
								formField: dateField,
								style: .plain,
								title: "Дата",
								subtitle: nil,
								placeHolder: "DD.MM.YYYY",
								errorMessage: ""
							)
							.padding([.leading, .trailing], 16)
						}
						
						ZStack {
							RoundedRectangle(cornerRadius: 12, style: .continuous)
								.stroke(Color(white: 0.94), lineWidth: 1)
								.background(Color(red: 0.97, green: 0.98, blue: 1))
								.padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
							
							CovidQuestionFiveVariantView(variant: state.variants[4])
								.padding(EdgeInsets(top: 28, leading: 16, bottom: 12, trailing: 16))
								.onTapGesture {
									state.toggle(4)
								}
						}
					}
					
					Spacer()
				}
				.ignoresSafeArea()
				.background(Color(red: 0.98, green: 0.98, blue: 1))
				.navigationBarHidden(true)
				
			}
			
			AppRedButtonTabView(title: "Готово") {
				onNext?()
			}
		}
	}
}

final class CovidQuestionFivePageController: UIHostingController<CovidQuestionFivePage>, TestControllerProtocol {
	
	weak var delegate: TestControllerDelegate!

	weak var test: Test!
	
	override init(rootView: CovidQuestionFivePage) {
		super.init(rootView: rootView)
		self.rootView.onNext = { [weak self] in
			self?.test.moveNext()
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
	
	static func createInstance() -> CovidQuestionFivePageController {
		let vc = CovidQuestionFivePageController(rootView: .init())
		return vc
	}
}

