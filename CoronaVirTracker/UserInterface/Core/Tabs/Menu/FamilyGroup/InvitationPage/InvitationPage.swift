//
//  InvitationPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 23.11.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

class InvitationPageState: ObservableObject {
    
    @Published var isLoading = false
    @Published var invitations: [GroupInviteModel] = []
    
    init() {
        reloadInvites()
    }
    
    func replyTo(_ invitation: GroupInviteModel, status: Bool) {
        isLoading = true
        GroupsManager.shared.replyToInvite(invitation, accept: status) { [weak self] success, error in
            if error != nil {
                self?.reloadInvites()
                DispatchQueue.main.async {
                    NotificationManager.shared.post(.didDeleteMemberFromGroup)
                }
            }
        }
    }
    
    func reloadInvites() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        GroupsManager.shared.getAllInvites { success, error in
            DispatchQueue.main.async { [weak self] in
                if let models = success {
                    self?.invitations = models
                    self?.isLoading = false
                }
                self?.isLoading = false
            }
        }
    }
}

struct InvitationPage: View {
    
    @Environment(\.presentationMode) var mode
    
    @ObservedObject var state = InvitationPageState()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    ZStack {
                        HStack {
                            Spacer()
                            Button {
                                
                                mode.wrappedValue.dismiss()
                                
                            } label: {
                                Text(locStr("Done"))
                                    .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                    .foregroundColor(Color(Style.TextColors.mainRed))
                            }
                        }
                        Text(locStr("Notification"))
                            .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(Style.TextColors.commonText))
                    }
                    .padding(EdgeInsets(top: 30, leading: 16, bottom: 30, trailing: 16))
                    Color(red: 0.89, green: 0.94, blue: 1)
                        .frame(height: 1)
                }
                
                ScrollView {
                    ForEach(state.invitations, id: \.id) { invitation in
                        HStack {
                            VStack {
                                ZStack {
                                    Circle()
                                        .stroke(Color(red: 0.89, green: 0.94, blue: 1), lineWidth: 1)
                                        .frame(width: 50, height: 50)
                                    Text(getSenderInitials(invitation))
                                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                                }
                                
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text("\(getInvitationSenderName(invitation)) " + locStr("invites you to a family group."))
                                    .font(CustomFonts.createInter(weight: .regular, size: 15))
                                Button {
                                    state.replyTo(invitation, status: true)
                                } label: {
                                    ZStack {
                                        Capsule(style: .continuous)
                                            .fill(Color(Style.TextColors.mainRed))
                                            .frame(width: 220, height: 40)
                                        Text(locStr("Accept the invitation"))
                                            .foregroundColor(.white)
                                            .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                    }
                                }
                                
                                Button {
                                    state.replyTo(invitation, status: false)
                                } label: {
                                    ZStack {
                                        Capsule(style: .continuous)
                                            .stroke(Color(Style.TextColors.mainRed), lineWidth: 1)
                                            .frame(width: 220, height: 40)
                                        Text(locStr("Refuse"))
                                            .foregroundColor(Color(Style.TextColors.mainRed))
                                            .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(16)
                        Color(red: 0.89, green: 0.94, blue: 1)
                            .frame(height: 1)
                    }
                }
            }
        }
        if state.isLoading {
            ZStack {
                BlurView()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    private func getInvitationSenderName(_ model: GroupInviteModel) -> String {
        model.recipient?.profile?.name ?? ""
    }
    
    private func getSenderInitials(_ model: GroupInviteModel) -> String {
        guard let string = model.recipient?.profile?.name else { return "--" }
        var splitted = string.split(separator: " ")
        splitted.removeAll { str in
            str.trimmingCharacters(in: .whitespaces).isEmpty
        }
        let firstChars = splitted.map { String($0.first ?? "-") }
        return firstChars.joined()
    }
}
