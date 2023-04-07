//
//  FamilyGroupMainPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 08.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct FamilyGroupMainPage: View {
    
    @ObservedObject var groupState = FamilyGroupManager.shared
    
    var user = RealmUserModel.getCurrent()
    
    @Environment(\.presentationMode) var mode
    
    var onAddNewMember: (() -> ())?
    var onDeleteGroup: (() -> ())?
    var onLeaveGroup: (() -> ())?
    var onUserTapped: ((UserModel) -> ())?
    
    var body: some View {
        VStack(spacing: 0) {
            
            Color.white
                .frame(height: 30)
            ZStack {
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("orange_back")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    
                    Menu {
                        if groupState.group?.isCurrentUserCreator ?? true {
                            Button(action: {
                                onAddNewMember?()
                            }) {
                                Label(locStr("Add member"), systemImage: "plus.circle")
                            }
                            
                            if #available(iOS 15.0, *) {
                                Button(role: .destructive, action: {
                                    onDeleteGroup?()
                                }) {
                                    Label(locStr("Delete group"), systemImage: "trash")
                                        .foregroundColor(.red)
                                }
                            } else {
                                Button {
                                    onDeleteGroup?()
                                } label: {
                                    Label(locStr("Delete group"), systemImage: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        } else {
                            if #available(iOS 15.0, *) {
                                Button(role: .destructive, action: {
                                    onLeaveGroup?()
                                }) {
                                    Label(locStr("Leave the group"), systemImage: "trash")
                                        .foregroundColor(.red)
                                }
                            } else {
                                Button {
                                    onLeaveGroup?()
                                } label: {
                                    Label(locStr("Leave the group"), systemImage: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    } label: {
                        Text(locStr("More"))
                            .foregroundColor(Color(Style.TextColors.mainRed))
                            .font(CustomFonts.createInter(weight: .regular, size: 15))
                    }

                }
                Text(locStr("My family"))
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
            .background(Color.white)
            .foregroundColor(.black)
            
            ScrollView {
                
                VStack(spacing: 10) {
                    Color.clear
                        .frame(height: 20)
                    VStack {
                        
                        AvatarView(user: user?.model())
                        
                        Text(user?.model()?.profile?.name ?? "--")
                            .font(CustomFonts.createInter(weight: .bold, size: 22))
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Text(locStr("Organizer"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .foregroundColor(Color(Style.TextColors.gray))
                        Color.clear
                            .frame(height: 10)
                    }
                    .frame(maxWidth: .infinity)
                    
                    buildFamilyGroup()
                    
                    if groupState.group?.isCurrentUserCreator ?? true {
                        MenuFamilyGroupMainWaitListView()
                    }
                    
                }
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onAppear {
            print("@LOAD GROUP")
            
            groupState.loadAll()
        }
    }
    
    private func buildFamilyGroup() -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Text(locStr("My family"))
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .foregroundColor(Color(Style.TextColors.commonText))
                Text("(\(groupState.group?.allMembers.count ?? 0))")
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .foregroundColor(Color(Style.TextColors.gray))
                
                Spacer()
                
            }
            .padding([.leading, .trailing], 16)
            
            VStack(alignment: .leading, spacing: 0) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 12) {
                        Color.clear
                            .frame(width: 4)
                        
                        if groupState.group?.isCurrentUserCreator ?? true {
                            VStack {
                                Image("NewMember")
                                    .frame(width: 90, height: 90)
                                    .cornerRadius(45)
                                Text(locStr("Add to group\n"))
                                    .multilineTextAlignment(.center)
                                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                                    .foregroundColor(Color(Style.TextColors.gray))
                            }.onTapGesture {
                                onAddNewMember?()
                            }
                        }
                        
                        if !(groupState.group?.members.isEmpty ?? true) {
                            ForEach(
                                groupState.group?.allMembers ?? [],
                                id: \.id
                            ) { member in
                                VStack {
                                    ZStack {
                                        Color.white
                                            .frame(width: 90, height: 90, alignment: .center)
                                            .cornerRadius(45)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color(Style.Stroke.lightGray), lineWidth: 1)
                                            )
                                        Text(getProfileInitials(member.profile?.name))
                                            .font(CustomFonts.createInter(weight: .bold, size: 23))
                                            .foregroundColor(Color(Style.TextColors.commonText))
                                        AvatarView(user: member)
                                    }
                                    
                                    Text(getProfileName(member.profile?.name))
                                        .multilineTextAlignment(.center)
                                        .font(CustomFonts.createInter(weight: .regular, size: 14))
                                        .foregroundColor(Color(Style.TextColors.gray))
                                }
                                .onTapGesture {
                                    // userTapped?(member)
                                }
                                .onLongPressGesture {
                                    // guard member.id != KeyStore.getIntValue(for: .currentUserId) else { return }
                                    /// onLongPress?(member)
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                            }
                        }
                    }
                }
            }
            .cornerRadius(14)
        }
        .padding([.top, .bottom], 16)
    }
    
    private func getProfileName(_ string: String?) -> String {
        guard let string = string else { return "--" }
        var splitted = string.split(separator: " ")
        splitted.removeAll { str in
            str.trimmingCharacters(in: .whitespaces).isEmpty
        }
        return splitted.joined(separator: "\n")
    }
    
    private func getProfileInitials(_ string: String?) -> String {
        guard let string = string else { return "--" }
        var splitted = string.split(separator: " ")
        splitted.removeAll { str in
            str.trimmingCharacters(in: .whitespaces).isEmpty
        }
        let firstChars = splitted.map { String($0.first ?? "-") }
        return firstChars.joined()
    }
}
 
final class FamilyGroupMainHostingController: UIHostingController<FamilyGroupMainPage> {
    
    override init(rootView: FamilyGroupMainPage) {
        super.init(rootView: rootView)
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
        
        self.rootView.onAddNewMember = { [weak self] in
            self?.addNewMember()
        }
        self.rootView.onDeleteGroup = { [weak self] in
            self?.deleteGroup()
        }
        self.rootView.onLeaveGroup = { [weak self] in
            self?.leaveGroup()
        }
        self.rootView.onUserTapped = { [weak self] user in
            self?.pushUserProfileController(user)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addNewMember() {
        let vc = FamilyGroupAddNewMemberHostingController.createInstance()
        present(vc, animated: true)
    }
    
    func pushUserProfileController(_ user: UserModel) {
        let vc = MemberHostingController.createInstance(user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func deleteGroup() {
        let alert = UIAlertController(
            title: locStr("Deleting a family group"),
            message: locStr("Are you sure you want to delete the family group?"),
            preferredStyle: .alert
        )
        alert.addAction(.init(title: locStr("Delete group"), style: .destructive) { _ in
            FamilyGroupManager.shared.deleteCurrentGroup()
        })
        alert.addAction(.init(title: locStr("Cancel"), style: .cancel))
        present(alert, animated: true)
    }
    private func leaveGroup() {
        let alert = UIAlertController(
            title: locStr("Leaving a family group"),
            message: locStr("Are you sure you want to leave the family group?"),
            preferredStyle: .alert
        )
        alert.addAction(.init(title: locStr("Leave group"), style: .destructive) { _ in
            FamilyGroupManager.shared.leaveCurrentGroup()
        })
        alert.addAction(.init(title: locStr("Cancel"), style: .cancel))
        present(alert, animated: true)
    }
}
