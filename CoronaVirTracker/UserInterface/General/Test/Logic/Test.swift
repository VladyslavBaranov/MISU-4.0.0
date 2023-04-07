//
//  Test.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 22.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import UIKit

class Test: NSObject, UIGestureRecognizerDelegate {
	
	weak var sourceViewController: UIViewController!
	
	func moveNext() {}
	func moveBack() {}
	
	func start() {}
	func cancel() {}
	
}

extension Test {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		true
	}
}
