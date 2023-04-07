//
//  HeartTest.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 24.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

final class HeartTest: Test {
	
	private let testName = "Рівень ризику\nхвороб серця"
	
	private var currentQuestionIndex = 0
	
	var navigationController: UINavigationController!
	
	override func moveNext() {
		switch currentQuestionIndex {
		case 0:
			moveToSecondQuestion()
		case 1:
			moveToThirdQuestion()
		case 2:
			moveToFourthQuestion()
		case 3:
			moveToFifthQuestion()
		case 4:
			moveToSixthQuestion()
		case 5:
			moveToSeventhQuestion()
		case 6:
			moveToEighthQuestion()
		case 7:
			moveToNinethQuestion()
		case 8:
			toggleLoading()
			HeartTestManager.shared.requestResult(
				.init(pain: 1, smoke: false, unconscious: false, dyspneic: false, edema: 1, diabetes: 0)) { model in
					DispatchQueue.main.async { [weak self] in
						self?.toggleLoading()
						if let model = model {
							self?.presentResult(model.result)
						}
					}
				}
		default:
			break
		}
		currentQuestionIndex += 1
	}
	
	override func moveBack() {
		currentQuestionIndex -= 1
	}
	
	override func start() {
		let firstQuestionVC = PickerTestContoller.createInstance(
			.init(
				testName: testName,
				questionIndex: 1,
				testQuestionCount: 9,
				statement: "Вкажіть дату народження",
				mode: .date
			)
		)
		firstQuestionVC.delegate = self
		firstQuestionVC.test = self
		navigationController = UINavigationController(rootViewController: firstQuestionVC)
		navigationController.interactivePopGestureRecognizer?.delegate = self
		sourceViewController.present(navigationController, animated: true)
	}
	
	override func cancel() {
		
	}
	
}

// UI Methods
private extension HeartTest {
	func toggleLoading() {
		guard let topVc = navigationController.topViewController as? BasicVariantsTestController else {
			return
		}
		topVc.rootView.isLoading = true
	}
	func presentResult(_ value: Double) {
		guard let topVc = navigationController.topViewController as? BasicVariantsTestController else {
			return
		}
		let alert = UIAlertController(title: "Result", message: "\(value)", preferredStyle: .alert)
		alert.addAction(.init(title: "Cancel", style: .default))
		topVc.present(alert, animated: true)
	}
}

extension HeartTest {
	func moveToSecondQuestion() {
		let controller = PickerTestContoller.createInstance(
			.init(
				testName: testName,
				questionIndex: 2,
				testQuestionCount: 9,
				statement: "Вкажіть параметри зросту",
				mode: .interval(120, 210)
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToThirdQuestion() {
		let controller = PickerTestContoller.createInstance(
			.init(
				testName: testName,
				questionIndex: 3,
				testQuestionCount: 9,
				statement: "Вкажіть параметри ваги",
				mode: .interval(30, 180)
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToFourthQuestion() {
		let controller = HeartQuestionFourController.createInstance()
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToFifthQuestion() {
		let controller = BasicVariantsTestController.createInstance(
			.init(
				testName: testName,
				questionIndex: 5,
				testQuestionCount: 9,
				statement: "Чи траплялись втрати свідомості\nостаннім часом?",
				variants: ["Ні, не траплялись", "Так, траплялись"],
				subtitle: ""
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToSixthQuestion() {
		let controller = BasicVariantsTestController.createInstance(
			.init(
				testName: testName,
				questionIndex: 6,
				testQuestionCount: 9,
				statement: "Чи буває у Вас задишка в стані\nспокою?",
				variants: ["Ні, не буває", "Так, буває"],
				subtitle: ""
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToSeventhQuestion() {
		let controller = BasicVariantsTestController.createInstance(
			.init(
				testName: testName,
				questionIndex: 7,
				testQuestionCount: 9,
				statement: "Чи відчуваєте набряк нижніх кінцівок\nввечері?",
				variants: ["Ні, не відчуваю", "Так, відчуваю", "Важко відповісти"],
				subtitle: ""
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToEighthQuestion() {
		let controller = BasicVariantsTestController.createInstance(
			.init(
				testName: testName,
				questionIndex: 8,
				testQuestionCount: 9,
				statement: "Чи є у Вас схильність до діабету?",
				variants: ["Ні, немає", "Так, є", "Важко відповісти"],
				subtitle: ""
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToNinethQuestion() {
		let controller = BasicVariantsTestController.createInstance(
			.init(
				testName: testName,
				questionIndex: 9,
				testQuestionCount: 9,
				statement: "Чи маєте звичку палити?",
				variants: ["Ні, не має", "Так, маю"],
				subtitle: ""
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
}

extension HeartTest: TestControllerDelegate {
	func didAnswerWithInteger(_ integer: Int, qIndex: Int) {
		
	}
	
	func didAnswerWithDate(_ date: Date, qIndex: Int) {
		
	}
	
	func didAnswerWithString(_ string: String, vIndex: Int, qIndex: Int) {
		
	}
	
	func didAnswerWithMultipleValues(_ values: [Any], qIndex: Int) {
		
	}
}
