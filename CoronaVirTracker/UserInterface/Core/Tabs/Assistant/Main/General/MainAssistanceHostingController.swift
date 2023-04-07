//
//  MainAssistanceHostingController.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 29.06.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI
import MessageUI

class MainAssistanceHostingController: UIHostingController<AssistanceMainPage> {
    
    override init(rootView: AssistanceMainPage) {
        super.init(rootView: rootView)
        self.rootView.onDoctorLinkTapped = { [weak self] in
            self?.pushOnlineDoctorsController()
        }
        self.rootView.onRiskGroupTapped = { [weak self] in
            self?.pushRiskGroupController()
        }
        self.rootView.onHowItWorksTapped = { [weak self] in
            self?.pushHowItWorksController()
        }
        self.rootView.onChatTapped = { [weak self] in
            self?.onChatTapped()
        }
        self.rootView.onChatListTapped = { [weak self] in
            self?.onChatListTapped()
        }
        self.rootView.onHealthDataLinkTapped = { [weak self] in
            self?.onHealthDataLinkTapped()
        }
        self.rootView.onRegisterTapped = { [weak self] in
            self?.onRegisterTapped()
        }
        self.rootView.onNotificationsTapped = { [weak self] in
            self?.onNotificationsTapped()
        }
        self.rootView.onChatListIconTapped = { [weak self] in
            self?.onChatListTapped()
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    private var assistanceWasShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.applicationIconBadgeNumber = RealmMessage.getUnseenMessages().count
        
        if !assistanceWasShown {
            AssistantManager.shared.getInsuranceStatus { result, error in
                if let result = result {
                    if !result.activate {
                        DispatchQueue.main.async { [weak self] in
                            let hostingController = WelcomingAssistanceHostingController(rootView:  WelcomingAssistancePage())
                            let nav = UINavigationController(rootViewController: hostingController)
                            self?.present(nav, animated: true)
                        
                            self?.assistanceWasShown = true
                        }
                    }
                }
            }
        }
        
        if KeyStore.getStringValue(for: .userCountry) == nil {
            presentCountrySelectionIfNeeded()
        }
                                            
    }
    
    func presentCountrySelectionIfNeeded() {
        let vc = DialogHostingController(rootView: CountrySelectionView())
        vc.preferredDialogSizing = .init(horizontal: .medium, vertical: .matched)
        vc.preferredDialogCornerRadius = 14
        present(vc, animated: true)
    }
    
    func onChatListTapped() {
        let controller = ChatListCollectionViewController() // UIHostingController(rootView: ChatListPage())
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func onHealthDataLinkTapped() {
        let controller = UIHostingController(rootView: HealthDataListPage())
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func onChatTapped() {
        
        if let country = KeyStore.getStringValue(for: .userCountry) {
            if country == "pl" {
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
                return
            }
        }
        // let controller = UIHostingController(rootView: ChatPage())
        // controller.hidesBottomBarWhenPushed = true
        // navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushRiskGroupController() {
        let controller = RiskGroupHostingController(rootView: .init())
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushOnlineDoctorsController() {
        let controller = OnlineDoctorHostingController(rootView: OnlineDoctorPage())
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentActivationController() {
        let controller = AssistantActivationHostingController(rootView: AssistantActivationPage())
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true)
    }
    
    func pushHowItWorksController() {
        let controller = UIHostingController(rootView: AssistanceHowItWorksPage())
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func onRegisterTapped() {
        let controller = AuthNumberInputHostingController(rootView: .init())
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    static func createInstance() -> UIViewController {
        let controller = MainAssistanceHostingController(rootView: AssistanceMainPage())
        let nav = UINavigationController(rootViewController: controller)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundImage = UIImage()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        nav.navigationBar.standardAppearance = navigationBarAppearance
        nav.navigationBar.compactAppearance = navigationBarAppearance
        nav.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        return nav
    }
    
    func onNotificationsTapped() {
        let vc = UIHostingController(rootView: NotificationsPage())
        present(vc, animated: true)
    }
}

extension MainAssistanceHostingController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension MainAssistanceHostingController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
