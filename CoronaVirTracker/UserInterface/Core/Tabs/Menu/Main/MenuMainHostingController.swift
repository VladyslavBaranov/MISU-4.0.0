//
//  MenuMainHostingController.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 11.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

class MenuMainHostingController: UIHostingController<MenuMainPage> {
    
    private var authShown = false
    
    override init(rootView: MenuMainPage) {
        super.init(rootView: rootView)
        
        self.rootView.onSettingsTapped = { [weak self] user in
            self?.pushSettings(user)
        }
        self.rootView.onUserTapped = { [weak self] user in
            self?.pushUserProfileController(user)
        }
        self.rootView.onFamilyGroupTapped = { [weak self] isAdmin in
            self?.pushFamilyGroup(isAdmin)
        }
        self.rootView.onShowAddNewMember = { [weak self] in
            self?.presentAddNewMember()
        }
        self.rootView.onLongPress = { [weak self] user in
            self?.presentSheetOnLongPress(user)
        }
        self.rootView.onOpenSubscriptions = { [weak self] in
            self?.openPaywall()
        }
        self.rootView.onOpenReport = { [weak self] in
            self?.openReport()
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(presentAuth),
            name: NotificationManager.shared.notificationName(for: .didLogout),
            object: nil
        )
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewDidAppearAfterLaunch),
            name: NotificationManager.shared.notificationName(for: .didHideLaunch),
            object: nil
        )
    }
    
    @objc func viewDidAppearAfterLaunch() {
        if !authShown {
        
            if KeychainUtility.getCurrentUserToken() == nil {
                presentAuth()
            } else {
                self.rootView.pageState.isUpdating = true
                TokenVerifier.shared.verify(KeychainUtility.getCurrentUserToken() ?? "") { [weak self] isVerified in
                    DispatchQueue.main.async { [weak self] in
                        self?.rootView.pageState.isUpdating = false
                        if !isVerified {
                            self?.presentAuth()
                        } else {
                            self?.checkUpdate()
                            self?.checkForInvitations()
                        }
                    }
                }
            }
            authShown = true
        }
    }
    
    func openReport() {
        let controller = UIHostingController(rootView: ReportPage())
        controller.modalPresentationStyle = .fullScreen
        controller.overrideUserInterfaceStyle = .dark
        present(controller, animated: true)
    }
    
    func openPaywall() {
        let controller = UIHostingController(rootView: SubscriptionPage())
        present(controller, animated: true)
    }
    
    func pushSettings(_ user: RealmUserModel?) {
        let vc = SettingsPageController(rootView: .init(user: user))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    static func createInstance() -> UIViewController {
        let controller = MenuMainHostingController(rootView: .init())
        return UINavigationController(rootViewController: controller)
    }
    
    func pushUserProfileController(_ user: UserModel) {
        let vc = MemberHostingController.createInstance(user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushFamilyGroup(_ isAdmin: Bool) {
        let vc = FamilyGroupMainHostingController(rootView: .init())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAddNewMember() {
        let vc = FamilyGroupAddNewMemberHostingController.createInstance()
        present(vc, animated: true)
    }
    
    func checkForInvitations() {
        GroupsManager.shared.getAllInvites { success, error in
            if let models = success {
                if models.contains(where: { $0.status == nil }) {
                    DispatchQueue.main.async { [weak self] in
                        let vc = UIHostingController(rootView: InvitationPage())
                        self?.present(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func presentSheetOnLongPress(_ user: UserModel) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: locStr("Call"), style: .default) { _ in
            if let user = ChatLocalManager.shared.getChatWithUser(id: user.id)?.getParticipant(id: user.id) {
                if let phoneCallURL = URL(string: "tel://\(user.mobile)") {
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }
                }
            }
        })
        alert.addAction(.init(title: locStr("Text"), style: .default) { [weak self] _ in
            if let chat = ChatLocalManager.shared.getChatWithUser(id: user.id) {
                let controller = UIHostingController(rootView: ChatPage(chat))
                controller.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        })
        
        if let groupData = RealmJSON.retreive(for: .group) {
            if let group = try? JSONDecoder().decode(GroupModel.self, from: groupData) {
                if group.isCurrentUserCreator {
                    alert.addAction(.init(title: locStr("Remove from family group"), style: .destructive) { [weak self] _ in
                        self?.deleteUserFromGroup(user)
                    })
                }
            }
        }
        
        alert.addAction(.init(title: locStr("Cancel"), style: .cancel))
        present(alert, animated: true)
    }
    
    func deleteUserFromGroup(_ user: UserModel) {
        guard let name = user.profile?.name else { return }
        let string = locStr("Are you sure you want to remove ") + name + locStr(" from the family group?")
        let alert = UIAlertController(
            title: locStr("Deleting a member"), message: string, preferredStyle: .alert)
        alert.addAction(.init(title: locStr("Delete member"), style: .destructive) { _ in
            if let groupData = RealmJSON.retreive(for: .group) {
                if let group = try? JSONDecoder().decode(GroupModel.self, from: groupData) {
                    GroupsManager.shared.delete(userId: user.id, fromGroup: group.id) { success, error in
                        DispatchQueue.main.async {
                            NotificationManager.shared.post(.didDeleteMemberFromGroup)
                        }
                    }
                }
            }
        })
        alert.addAction(.init(title: locStr("Cancel"), style: .cancel))
        present(alert, animated: true)
    }
    
    func checkUpdate() {
        AppMetadataManager.shared.getAppInfoResults { result in
            if let result = result {
                if let info = result.results.first {
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        if info.version > version {
                            DispatchQueue.main.async { [weak self] in
                                let vc = UIHostingController(rootView: AppUpdatePage(appVersion: info.version))
                                vc.modalPresentationStyle = .fullScreen
                                self?.present(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension MenuMainHostingController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

private extension MenuMainHostingController {
    @objc func presentAuth() {
        let controller = AuthNumberInputHostingController(rootView: .init())
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

