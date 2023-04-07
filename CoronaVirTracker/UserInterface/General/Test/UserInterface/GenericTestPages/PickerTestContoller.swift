//
//  PickerTestContoller.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 23.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI
 
struct PickerTestPage: View {
	
	var model: PickerTestContoller.Model
	
	var onValueChanged: ((Int) -> ())?
	
	var backButtonTapped: (() -> ())?
	var onNext: (() -> ())?
	var onCancel: (() -> ())?
	
	private let columns: [GridItem] = [
		GridItem(.flexible()), GridItem(.flexible())
	]
	
	@State var date = Date()
	@State var value: Int = 0
	
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
					
					ScrollView {
						ZStack {
							RoundedRectangle(cornerRadius: 12, style: .continuous)
								.stroke(Color(white: 0.94), lineWidth: 1)
								.background(Color(red: 0.97, green: 0.98, blue: 1))
							
							switch model.mode {
							case .date:
								DatePicker("", selection: $date, displayedComponents: [.date])
									.datePickerStyle(WheelDatePickerStyle())
									.fixedSize()
							case .interval(let min, let top):
								
								Picker("", selection: $value) {
									ForEach(min...top, id: \.self) { index in
										Text("\(index)").tag(index)
									}
								}
								.pickerStyle(WheelPickerStyle())
								.onChange(of: value) { newValue in
									onValueChanged?(newValue)
								}
							}
							
							
							
						}
						.padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
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
			.onAppear {
				switch model.mode {
				case .interval(let min, let max):
					value = (min + max) / 2
				default:
					break
				}
			}
		}
	}
}

final class PickerTestContoller: UIHostingController<PickerTestPage>, TestControllerProtocol {
	
	weak var delegate: TestControllerDelegate!
	
	weak var test: Test!
	
	struct Model {
		
		enum Mode {
			case date
			case interval(Int, Int)
		}
		
		let testName: String
		let questionIndex: Int
		let testQuestionCount: Int
		let statement: String
		let mode: Mode
	}
	
	private var intValue: Int = 0
	
	override init(rootView: PickerTestPage) {
		super.init(rootView: rootView)
		
		self.rootView.onValueChanged = { [weak self] value in
			self?.intValue = value
		}
		self.rootView.onNext = { [weak self] in
			
			guard let strongSelf = self else { return }
			
			let model = strongSelf.rootView.model
			switch model.mode {
			case .interval(_, _):
				let int = strongSelf.intValue
				strongSelf.delegate.didAnswerWithInteger(int, qIndex: model.questionIndex)
			case .date:
				let date = strongSelf.rootView.date
				strongSelf.delegate.didAnswerWithDate(date, qIndex: model.questionIndex)
			}
			
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
	
	static func createInstance(_ model: PickerTestContoller.Model) -> PickerTestContoller {
		let vc = PickerTestContoller(rootView: .init(model: model))
		return vc
	}
}

