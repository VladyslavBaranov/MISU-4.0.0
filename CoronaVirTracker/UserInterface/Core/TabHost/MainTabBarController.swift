//
//  MainTabBarController.swift
//  CoronaVirTracker
//
//  Created by WH ak on 15.05.2020.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import SwiftUI

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
		delegate = self
        showLaunch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    static func createInstance() -> MainTabBarController {
        let tabBarController = MainTabBarController()
        tabBarController.initTabs()
        tabBarController.setupColors()
        return tabBarController
    }
}

private extension MainTabBarController {

    func setupColors() {
        tabBar.tintColor = Style.TextColors.mainRed
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = UIColor(red: 0.412, green: 0.466, blue: 0.604, alpha: 1)
        
    }
    
    func setup() {
        tabBar.tintColor = Style.TextColors.mainRed
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = UIColor(red: 0.412, green: 0.466, blue: 0.604, alpha: 1)
    }
    
    func initTabs() {
        let tabVCs = MainTabBarItem.allCases.map { tab -> UIViewController in
            return tab.viewController
        }
        setViewControllers(tabVCs, animated: false)
        selectedViewController = tabVCs[0]
    }
    
    func showLaunch() {
        let vc = UIHostingController(rootView: LaunchPage())
        vc.view.backgroundColor = .white
        addChild(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            
            UIView.animate(withDuration: 0.3) {
                vc.view.alpha = 0
            } completion: { _ in
                vc.willMove(toParent: nil)
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(4300)) {
            NotificationCenter.default.post(
                Notification(name: NotificationManager.shared.notificationName(for: .didHideLaunch))
            )
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		
		guard let fromView = selectedViewController?.view else { return false }
		guard let toView = viewController.view else { return false }
		
		if fromView != toView {
			UIView.transition(
				from: fromView,
				to: toView,
				duration: 0.25,
				options: [.transitionCrossDissolve]
			)
		}
		
		return true
	}
}
