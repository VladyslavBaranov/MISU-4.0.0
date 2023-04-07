//
//  SettingsPageController.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 07.01.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI
import MessageUI

final class SettingsPageController: UIHostingController<SettingsPage> {
    
    override init(rootView: SettingsPage) {
        super.init(rootView: rootView)
        
        self.rootView.onProfileTapped = { [weak self] user in
            let vc = ProfilePageController(rootView: .init(user: user))
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.rootView.onMailTapped = { [weak self] in
            self?.mail()
        }
        self.rootView.didPerformLogout = { [weak self] in
            self?.didPerformLogout()
        }
        self.rootView.onSelectCountry = { [weak self] in
            let vc = UIHostingController(rootView: MenuCountrySelectionPage())
            self?.present(vc, animated: true)
        }
        NotificationCenter.default.addObserver(
            self, selector: #selector(beginTestableAction(_:)),
            name: NotificationManager.shared.notificationName(for: .willBeginTestableAction), object: nil)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mail() {
        
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.setToRecipients(["support@misu.in.ua"])
            controller.delegate = self
            controller.setMessageBody("<p>\(locStr("Describe your question")):</p>", isHTML: true)
            present(controller, animated: true)
        } else {
            guard let url = URL(string: "https://misu.pp.ua/#feedback") else { return }
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    func didPerformLogout() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func beginTestableAction(_ notification: Notification) {
        guard let action = notification.object as? TestableAction else { return }
        switch action {
        case .heartList:
            let vc = _MenuUserSettingsIndicatorsController.createInstance(for: .heartrate)
            present(vc, animated: true)
        case .pressureList:
            let vc = _MenuUserSettingsIndicatorsController.createInstance(for: .pressure)
            present(vc, animated: true)
        case .oxygenList:
            let vc = _MenuUserSettingsIndicatorsController.createInstance(for: .oxygen)
            present(vc, animated: true)
        case .tempreatureList:
            let vc = _MenuUserSettingsIndicatorsController.createInstance(for: .temperature)
            present(vc, animated: true)
        case .shouldDisplayAssistanceWelcome:
            let hostingController = WelcomingAssistanceHostingController(rootView:  WelcomingAssistancePage())
            let nav = UINavigationController(rootViewController: hostingController)
            present(nav, animated: true)
        case .clearChats:
            RealmMessage.clear()
        case .getAPIResponse:
            let vc = _MenuUserSettingsAPIController.createInstance()
            present(vc, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SettingsPageController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
