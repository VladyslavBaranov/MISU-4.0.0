//
//  HeartQuestionFourPage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 26.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

fileprivate struct HeartQ5SubVariantView: View {
	
	let text: String
	let isSelected: Bool
	var onSelected: (() -> ())
	
	var body: some View {
		HStack(spacing: 12) {
			Button {
				onSelected()
			} label: {
				Image(isSelected ? "square-sel" : "square-uns")
					.resizable()
					.frame(width: 18, height: 18)
			}
			Text(text)
				.font(CustomFonts.createInter(weight: .regular, size: 14))
			Spacer()
		}
	}
}

final class HeartQuestionFourPageState: ObservableObject {
	
	@Published var selectedIndex = 0
	@Published var selectedSubVariant = 0
	
	let variants = ["Ні, не відчуваю", "Так, відчуваю"]
	let subvariants = [
		"Пекучий біль", "Тяжіння", "Різький біль",
		"Дискомфорт", "Глухий біль", "Стиснення"
	]
}
 
struct HeartQuestionFourPage: View {
	
	@ObservedObject var state = HeartQuestionFourPageState()
	
	var backButtonTapped: (() -> ())?
	var onNext: (() -> ())?
	var onCancel: (() -> ())?
	
	private let columns: [GridItem] = [
		GridItem(.flexible()), GridItem(.flexible())
	]
	
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
					Text("Рівень ризику\nхвороб серця")
						.font(CustomFonts.createInter(weight: .semiBold, size: 16))
						.multilineTextAlignment(.center)
						
				}
				.padding([.leading, .trailing], 16)
				.foregroundColor(.black)
				
				Color.clear
					.frame(height: 30)
				
				VStack(alignment: .center, spacing: 10) {
					
					Text("Питання 4 з 9")
						.font(CustomFonts.createInter(weight: .medium, size: 18))
						.foregroundColor(Color(red: 0.41, green: 0.47, blue: 0.6))
					
					Text("Ви відчуваєте Ви біль в грудній\nклітині, голові, плечі або предпліччі?")
						.font(CustomFonts.createInter(weight: .medium, size: 18))
						.multilineTextAlignment(.center)
					
					LazyVGrid(columns: columns, spacing: 11) {
						ForEach(0..<state.variants.count, id: \.self) { index in
							ZStack {
								RoundedRectangle(cornerRadius: 12)
									.stroke(
										state.selectedIndex == index ? Color(red: 0.36, green: 0.61, blue: 0.97) : Color(Style.Stroke.lightGray),
										lineWidth: 1
									)
									.background(Color.white.cornerRadius(12))
								VStack {
									HStack {
										Text(state.variants[index])
											.font(CustomFonts.createInter(weight: .regular, size: 15))
											.foregroundColor(
												state.selectedIndex == index ? Color(red: 0.36, green: 0.61, blue: 0.97) : Color(Style.TextColors.commonText)
											)
										Spacer()
									}
									Spacer()
								}
								.padding(16)
							}
							.frame(height: 130)
							.onTapGesture {
								state.selectedIndex = index
							}
						}
					}
					.padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
					
					if state.selectedIndex == 1 {
						Color.clear
							.frame(height: 30)
						HStack {
							Text("Вкажіть характер болю:")
								.font(CustomFonts.createInter(weight: .medium, size: 18))
							Spacer()
						}
						.padding([.leading, .trailing], 16)
						
						LazyVGrid(columns: columns, spacing: 15) {
							ForEach(0..<state.subvariants.count, id: \.self) { index in
								HeartQ5SubVariantView(
									text: state.subvariants[index],
									isSelected: index == state.selectedSubVariant
								) {
									state.selectedSubVariant = index
								}
							}
						}
						.padding(EdgeInsets(top: 12, leading: 19, bottom: 0, trailing: 19))
					}
					
				}
				
				Spacer()
			}
			.ignoresSafeArea()
			.background(Color(red: 0.98, green: 0.98, blue: 1))
			.navigationBarHidden(true)
			
            AppRedButtonTabView(title: "Далі") {
				onNext?()
			}
		}
	}
}

final class HeartQuestionFourController: UIHostingController<HeartQuestionFourPage>, TestControllerProtocol {
	
	weak var delegate: TestControllerDelegate!
	
	weak var test: Test!
	
	override init(rootView: HeartQuestionFourPage) {
		super.init(rootView: rootView)
		
		self.rootView.onNext = { [weak self] in
			guard let strongSelf = self else { return }
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
	
	static func createInstance() -> HeartQuestionFourController {
		let vc = HeartQuestionFourController(rootView: .init())
		return vc
	}
}

