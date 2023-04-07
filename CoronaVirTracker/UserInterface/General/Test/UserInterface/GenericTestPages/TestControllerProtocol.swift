//
//  TestControllerProtocol.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 23.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import Foundation

protocol TestControllerProtocol: AnyObject {
	var test: Test! { get set }
	var delegate: TestControllerDelegate! { get set }
}

protocol TestControllerDelegate: AnyObject {
	func didAnswerWithInteger(_ integer: Int, qIndex: Int)
	func didAnswerWithDate(_ date: Date, qIndex: Int)
	func didAnswerWithString(_ string: String, vIndex: Int, qIndex: Int)
	func didAnswerWithMultipleValues(_ values: [Any], qIndex: Int)
}
