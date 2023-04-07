//
//  ProfilePage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 06.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

class ProfilePageState: ObservableObject {
    
    var realmUserModel: RealmUserModel?
    var userModel: UserModel?
    
    var generalItems: [SettingsItem] = [
        .init(iconName: "profile_name", text: "-"),
        .init(iconName: "profile_birth", text: "-"),
        .init(iconName: "BlackPhone", text: "-", requiresChevron: false),
        // .init(iconName: "profile_email", text: "-")
    ]
    
    var privateItems: [SettingsItem] = [
        .init(iconName: "profile_sex", text: "-"),
        .init(iconName: "profile_height", text: "-"),
        .init(iconName: "profile_weight", text: "-"),
    ]
    
    init() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadCurrentUser),
            name: NotificationManager.shared.notificationName(for: .didUpdateCurrentUser), object: nil)
        
        realmUserModel = RealmUserModel.getCurrent()
        userModel = realmUserModel?.model()
        setUser()
    }
    
    func setUser() {
        guard let user = userModel else { return }
        
        generalItems[0].text = user.profile?.name ?? "--"
        
        if let date = user.profile?.birthdayDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            generalItems[1].text = formatter.string(from: date)
        }
        
        generalItems[2].text = user.number ?? "--"
        // generalItems[3].text = user.email ?? "--"
        
        let gender = user.profile?.gender
        privateItems[0].text = gender?.localized.capitalized ?? "--"

        let h = user.profile?.height ?? 0
        privateItems[1].text = "\(Int(h)) cm"
        
        let w = user.profile?.weight ?? 0
        privateItems[2].text = "\(Int(w)) kg"
        objectWillChange.send()
    }
    
    @objc func reloadCurrentUser() {
        realmUserModel = RealmUserModel.getCurrent()
        userModel = realmUserModel?.model()
        setUser()
        UserManager.shared.updateUserWithRealmIfNeeded()
        objectWillChange.send()
    }
    
}

struct ProfilePage: View {
    
    @State var user: RealmUserModel?
    
    @Environment(\.presentationMode) var mode
    
    var generalDataTapped: ((Int) -> ())?
    var privateDataTapped: ((Int) -> ())?
    var onChangeAvatarTapped: (() -> ())?
    var onDeleteProfileTapped: (() -> ())?
    
    @ObservedObject var state = ProfilePageState()
    
    var body: some View {
        VStack(spacing: 0) {
            
            Color.white
                .frame(height: 30)
            ZStack {
                HStack {
                    Button {
						NotificationManager.shared.post(.didUpdateCurrentUser)
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("orange_back")
                            .font(.system(size: 24))
                    }
                    Spacer()
                }
                Text(locStr("User profile"))
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            ScrollView {
                VStack(spacing: 20) {
                    AvatarView(user: user?.model())
                    Button {
                        onChangeAvatarTapped?()
                    } label: {
                        Text(locStr("Change picture"))
                            .font(CustomFonts.createInter(weight: .regular, size: 15))
                            .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.97))
                            .underline()
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(locStr("Basic data"))
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                    ForEach(0..<state.generalItems.count, id: \.self) { index in
                        SettingsPageItemCard(item: state.generalItems[index])
                            .contentShape(Rectangle())
                            .onTapGesture {
                                generalDataTapped?(index)
                            }
                        if index != 2 {
                            Color(red: 0.89, green: 0.94, blue: 1)
                                .frame(height: 0.7)
                        }
                    }
                }
                .padding(16)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(locStr("Personal parameters"))
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                    ForEach(0..<state.privateItems.count, id: \.self) { index in
                        SettingsPageItemCard(item: state.privateItems[index])
                            .contentShape(Rectangle())
                            .onTapGesture {
                                privateDataTapped?(index)
                            }
                        if index != 2 {
                            Color(red: 0.89, green: 0.94, blue: 1)
                                .frame(height: 0.7)
                        }
                    }
                }
                .padding(16)
                
                Color.clear
                    .frame(height: 40)
                
                Button {
                    onDeleteProfileTapped?()
                } label: {
                    Text(locStr("Delete profile"))
                        .font(CustomFonts.createInter(weight: .regular, size: 15))
                        .foregroundColor(.red)
                        .underline()
                }
                
                Color.clear
                    .frame(height: 100)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .top)
    }
}

final class ProfilePageController: UIHostingController<ProfilePage>, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override init(rootView: ProfilePage) {
        super.init(rootView: rootView)
        self.rootView.generalDataTapped = { [weak self] num in
            self?.pushGeneralDataEditScreen(num)
        }
        self.rootView.onChangeAvatarTapped = { [weak self] in
            self?.showAvatarAlert()
        }
        self.rootView.privateDataTapped = { [weak self] num in
            self?.pushPrivateDataEditScreen(num)
        }
        self.rootView.onDeleteProfileTapped = { [weak self] in
            self?.showProfileDeletionAlert()
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pushGeneralDataEditScreen(_ index: Int) {
        let user = rootView.user!
        
        if index == 0 {
            let vc = UIHostingController(rootView: UpdateNamePage(user: user))
            vc.hidesBottomBarWhenPushed = true
            vc.view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
            navigationController?.pushViewController(vc, animated: true)
        } else if index == 1 {
            let vc = UIHostingController(rootView: MenuUserUpdateBirthDatePage(user: user))
            vc.view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
            present(vc, animated: true)
        } else if index == 3 {
            let vc = UIHostingController(rootView: MenuUserUpdateEmailPage(user: user))
            vc.hidesBottomBarWhenPushed = true
            vc.view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func pushPrivateDataEditScreen(_ index: Int) {
        let user = rootView.user!
        
        if index == 0 {
            let vc = UIHostingController(rootView: MenuUserUpdateGenderPage(user: user))
            vc.view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
            present(vc, animated: true)
        } else if index == 1 {
            let vc = UIHostingController(rootView: MenuUserUpdateHeightPage(user: user))
            vc.view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
            present(vc, animated: true)
        } else if index == 2 {
            let vc = UIHostingController(rootView: MenuUserUpdateWeightPage(user: user))
            vc.view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
            present(vc, animated: true)
        }
        
    }
    
    func showAvatarAlert() {
        let style = UIDevice.current.userInterfaceIdiom == .phone ? UIAlertController.Style.actionSheet : .alert
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: style)
        alert.addAction(.init(title: locStr("Choose from the gallery"), style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self?.present(picker, animated: true)
        }))
        /*
        alert.addAction(.init(title: "Зробити світлину", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            self?.present(picker, animated: true)
        }))
        */
        alert.addAction(.init(title: locStr("Delete current photo"), style: .default, handler: { [weak self] _ in
            self?.updateAvatar(UIImage(named: "patientDefImage") ?? .init())
        }))
        alert.addAction(.init(title: locStr("Cancel"), style: .cancel))
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info[.originalImage] as? UIImage else { return }
        updateAvatar(img)
        picker.dismiss(animated: true)
    }
    
    func showProfileDeletionAlert() {
        let alert = UIAlertController(
            title: locStr("Deleting a profile"),
            message: locStr("Data cannot be recovered if the profile is deleted. Are you sure you want to delete your profile?"),
            preferredStyle: .alert
        )
        alert.addAction(.init(title: locStr("Delete profile"), style: .destructive) { _ in
            UserManager.shared.delete { success, error in
                if success {
                    AuthManager.shared.logout { success, error in
                        if success {
                            DispatchQueue.main.async { [weak self] in
                                self?.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            }
        })
        alert.addAction(.init(title: locStr("Cancel"), style: .cancel))
        present(alert, animated: true)
    }
    
    private func updateAvatar(_ image: UIImage) {
        guard let token = KeychainUtility.getCurrentUserToken() else { return }
        let data = image.jpegData(compressionQuality: 1)
        
        NotificationManager.shared.post(.didUpdateAvatar, object: image)
        
        let newURL = "IMG_\(UUID().uuidString).jpg"
        
        UserManager.shared.updateUser(
            token,
            params: [:],
            files: [.init(name: newURL, type: .imageJpg, data: data)]
        ) { result, error in
            DispatchQueue.main.async {
                NotificationManager.shared.post(.didUpdateAvatar, object: image)
            }
        }
    }
}

