//
//  WelcomingAssistanceHostingController.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 29.06.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

class WelcomingAssistanceHostingController: UIHostingController<WelcomingAssistancePage> {
    
    override init(rootView: WelcomingAssistancePage) {
        super.init(rootView: rootView)
        self.rootView.crossTapped = { [weak self] in
            self?.dismissSelf()
        }
        self.rootView.onActivate = { [weak self] in
            let vc = AssistantActivationHostingController(rootView: .init())
            let navigationController = UINavigationController(rootViewController: vc)
            self?.present(navigationController, animated: true)
        }
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.interactivePopGestureRecognizer?.delegate = self
	}
    
    func dismissSelf() {
        dismiss(animated: true)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WelcomingAssistanceHostingController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		true
	}
}
