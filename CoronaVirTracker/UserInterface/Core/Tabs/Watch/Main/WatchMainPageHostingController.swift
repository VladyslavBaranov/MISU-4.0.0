//
//  WatchMainPageHostingController.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 02.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

final class WatchMainPageHostingController: UIHostingController<WatchMainPage> {
    
    private var vc: WatchMainWelcomeHostingController!
	
	override init(rootView: WatchMainPage) {
		super.init(rootView: rootView)
		self.rootView.onWatchConnectionTapped = { [weak self] in
			self?.presentConnectionController()
		}
		self.rootView.onCharacteristicTapped = { [weak self] indicator in
			self?.onCharacteristicTapped(indicator)
		}
		self.rootView.shouldPresentMonitoring = { [weak self] in
			self?.shouldPresentMonitoring()
		}
		self.rootView.onIndicatorsTapped = { [weak self] in
			self?.pushIndicatorsList()
		}
        self.rootView.shouldPushECG = { [weak self] in
            let vc = ECGFingerPressHostingController(rootView: ECGFingerPressPage())
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.rootView.onECGMore = { [weak self] in
            let vc = ECGHistoryHostingController(rootView: ECGHistoryPage())
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
		navigationController?.interactivePopGestureRecognizer?.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        KeyStore.dropValue(for: .didConnectWatchOnce)
		navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(removeConnectionView), name: NotificationManager.shared.notificationName(for: .didConnectWatch), object: nil
        )
	}
    
    @objc func removeConnectionView() {
        vc?.willMove(toParent: nil)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.vc?.view.alpha = 0
        } completion: { [weak self] _ in
            self?.vc?.view.removeFromSuperview()
            self?.vc?.removeFromParent()
        }
    }
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if WatchConnectionManager.shared.currentWatch() == nil {
            vc = WatchMainWelcomeHostingController(rootView: .init())
            
            addChild(vc)
            vc.view.frame = view.frame
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
            
            
            vc.delegate = self
            vc.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
        }
        
        self.rootView.state.refreshLocally(updaitingUI: true)
        
		//if WatchConnectionManager.shared.getCurrentWatch() == nil {
		//	let connectionController = WatchListHostingController(rootView: .init())
		//	present(connectionController, animated: true)
		//}/
	}
    
    
	
	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func pushIndicatorsList() {
		let controller = WatchIndicatorsListHostingController(rootView: .init())
		navigationController?.pushViewController(controller, animated: true)
	}
	
	func shouldPresentMonitoring() {
		let controller = IntensiveMonitoringController(rootView: IntensiveMonitoringPage())
        let nav = UINavigationController(rootViewController: controller)
		present(nav, animated: true)
	}
	
	func onHealthDataLinkTapped() {
		let controller = UIHostingController(rootView: HealthDataListPage())
		navigationController?.pushViewController(controller, animated: true)
	}
	
	func presentConnectionController() {
		let controller = WatchListHostingController(rootView: .init())
		controller.delegate = self
		let nav = UINavigationController(rootViewController: controller)
		present(nav, animated: true)
	}
	
	func onCharacteristicTapped(_ indicator: __HealthIndicatorType) {
		var loaderName: String = ""
		switch indicator {
		case .sleep:
			let vc = SleepIndicatorHostingController(rootView: .init())
			navigationController?.pushViewController(vc, animated: true)
			return
		case .pressure:
			loaderName = "BloodPressure"
		case .heartrate:
			loaderName = "Heartrate"
		case .temperature:
			loaderName = "Temperature"
		case .oxygen:
			loaderName = "Oxygen"
		case .sugar:
			loaderName = "Sugar"
		case .insuline:
			loaderName = "Insuline"
		default:
			break
		}
		let vc = GenericIndicatorHostingController.createInstance(loaderName: loaderName, indicator: indicator)
		navigationController?.pushViewController(vc, animated: true)
	}
	
	static func createInstance() -> UINavigationController {
		let controller = WatchMainPageHostingController(rootView: .init())
		return UINavigationController(rootViewController: controller)
	}
}

extension WatchMainPageHostingController: WatchListHostingControllerDelegate {
    func shouldPresentWatchDataReading(_ fromWatch: AbstractWatch) {
        let vc = WatchDataReadingHostingController(rootView: WatchDataReading())
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        present(vc, animated: true)
    }
}

extension WatchMainPageHostingController: WatchDataReadingHostingControllerDelegate {
	func didLoadDataFromWatch(_ models: [HealthIndicatorViewModel]) {
		// let vc = UIHostingController(rootView: WatchNotificationPage())
		// present(vc, animated: true)
	}
}

extension WatchMainPageHostingController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		true
	}
}

extension WatchMainPageHostingController: WatchMainWelcomeDelegate {
    func didDismiss(_ cotroller: WatchMainWelcomeHostingController!, shouldPresentConnection: Bool) {
        if shouldPresentConnection {
            presentConnectionController()
        }
    }
}
