//
//  CovidTest.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 22.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct BMIResult {
	enum State { case normal, low, high }
	var state: State = .normal
	var title: String = ""
	var survey: String = ""
}

private struct CovidTestAnswersModel {
	
	var bodyHeight = 0
	var bodyWeight = 0
	
	func getBMI() -> Double {
		let w = Double(bodyWeight)
		let h = Double(bodyHeight) / 100
		return w / (h * h)
	}
	
	func getBMISurvey() -> BMIResult {
		let bmi = getBMI()
		var result = BMIResult()
		switch bmi {
		case 0..<18.5:
			result.state = .low
			result.title = "Відхилення від норми!"
			result.survey = "Показник ІМТ нижчий за норму. Пам’ятайте: надмірна або занижена вага може призвести до виникнення та розвитку захворювань"
		case 18.5...24.9:
			result.state = .normal
			result.title = "Дані відповідають нормі!"
			result.survey = "Так тримати! Пам’ятайте: надмірна або занижена вага може призвести до виникнення та розвитку захворювань"
		default:
			result.state = .high
			result.title = "Відхилення від норми!"
			result.survey = "Показник ІМТ вищий за норму. Пам’ятайте: надмірна або занижена вага може призвести до виникнення та розвитку захворювань"
		}
		return result
	}
	
}

final class CovidTest: Test {
	
	private var answerModel = CovidTestAnswersModel()
	
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
			moveToMICalculation()
		case 4:
			moveToMISurvey()
		case 5:
			moveToFifthQuestion()
		case 6:
			moveToSixthQuestion()
		case 7:
			moveToFinalCalculation()
		case 8:
			moveToFinalSurvey()
		default:
			break
		}
		currentQuestionIndex += 1
	}
	
	override func moveBack() {
		currentQuestionIndex -= 1
	}
	
	override func start() {
		let firstQuestionVC = BasicVariantsTestController.createInstance(
			.init(
				testName: "Рівень ризику\nCovid-19",
				questionIndex: 1,
				testQuestionCount: 6,
				statement: "Вкажіть Вашу стать",
				variants: ["Жінка", "Чоловік"],
				subtitle: ""
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

extension CovidTest {
	private func moveToSecondQuestion() {
		let controller = PickerTestContoller.createInstance(
			.init(
				testName: "Рівень ризику\nCovid-19",
				questionIndex: 2,
				testQuestionCount: 6,
				statement: "Вкажіть дату народження",
				mode: .date
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToThirdQuestion() {
		let controller = PickerTestContoller.createInstance(
			.init(
				testName: "Рівень ризику\nCovid-19",
				questionIndex: 3,
				testQuestionCount: 6,
				statement: "Вкажіть параметри зросту",
				mode: .interval(120, 210)
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToFourthQuestion() {
		let controller = PickerTestContoller.createInstance(
			.init(
				testName: "Рівень ризику\nCovid-19",
				questionIndex: 4,
				testQuestionCount: 6,
				statement: "Вкажіть параметри ваги",
				mode: .interval(30, 180)
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToMICalculation() {
		let controller = CalculationPageHostingController.createInstance(
			.init(imageName: "MassIndexImage", title: "Обчислюємо індекс маси тіла...")
		)
		controller.delegate = self
		navigationController?.pushViewController(controller, animated: true)
		navigationController.viewControllers = [controller]
	}
	
	private func moveToMISurvey() {
		let controller = ScalarResultPageHostingController.createInstance(
			.init(
				imageName: "MassIndexImage",
				title: "Індекс маси Вашого тіла:",
				number: answerModel.getBMI(),
				bmiResult: answerModel.getBMISurvey()
			)
		)
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToFifthQuestion() {
		let controller = CovidQuestionFivePageController.createInstance()
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToSixthQuestion() {
		let controller = BasicVariantsTestController.createInstance(
			.init(
				testName: "Рівень ризику\nCovid-19",
				questionIndex: 6,
				testQuestionCount: 6,
				statement: "Чи маєте Ви розлади під час сну, як\nзатримка дихання тощо?",
				variants: ["Ні, не маю", "Так, маю"],
				subtitle: "* Відомий як синдром апное. Основні симптоми: храп, надмірна рухливість під час сну, пробудження та голосний вдих"
			)
		)
		controller.delegate = self
		controller.test = self
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func moveToFinalCalculation() {
		let controller = CalculationPageHostingController.createInstance(
			.init(imageName: "ActivationWoman", title: "Завантажуємо результат...")
		)
		controller.delegate = self
		navigationController?.pushViewController(controller, animated: true)
		navigationController.viewControllers = [controller]
	}
	
	private func moveToFinalSurvey() {
		let controller = CovidSurveyPageHostingController.createInstance()
		navigationController.pushViewController(controller, animated: true)
	}
}

extension CovidTest: CalculationPageDelegate {
	func didCalculate() {
		moveNext()
	}
}

extension CovidTest: TestControllerDelegate {
	func didAnswerWithInteger(_ integer: Int, qIndex: Int) {
		if qIndex == 3 {
			answerModel.bodyHeight = integer
		} else if qIndex == 4 {
			answerModel.bodyWeight = integer
		}
	}
	
	func didAnswerWithDate(_ date: Date, qIndex: Int) {}
	
	func didAnswerWithString(_ string: String, vIndex: Int, qIndex: Int) {}
	
	func didAnswerWithMultipleValues(_ values: [Any], qIndex: Int) {}
}
