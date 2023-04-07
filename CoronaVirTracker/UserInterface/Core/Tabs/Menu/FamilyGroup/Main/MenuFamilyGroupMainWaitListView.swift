//
//  MenuFamilyGroupMainWaitListView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 06.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct MenuFamilyGroupMainWaitListView: View {
    
    @ObservedObject var groupState = FamilyGroupManager.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(locStr("Waiting") + " (\(groupState.invites.count))")
                    .font(CustomFonts.createInter(weight: .medium, size: 18))
                ForEach(groupState.invites, id: \.id) { invitation in
                    HStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(invitation.recipient?.profile?.name ?? "Unknown")
                                .font(CustomFonts.createInter(weight: .semiBold, size: 15))
                            Text(locStr("User"))
                                .font(CustomFonts.createInter(weight: .regular, size: 14))
                                .foregroundColor(Color(Style.TextColors.gray))
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(16)
        .onAppear {
            
//            let savedInvitations = RealmGroupInvitation.getAll()
//            let ids = savedInvitations.map { $0.id }
//            self.invitations = savedInvitations
            
//            GroupManager.shared.getInvitations { invitations in
//                DispatchQueue.main.async {
//                    let nonNilInvitations = invitations.filter { $0.status != nil }
//                    let serverIds = nonNilInvitations.map { $0.id }
//                    if serverIds != ids {
//                        self.invitations = invitations
//                        RealmGroupInvitation.performPreOverwrite()
//                        for invitation in invitations {
//                            invitation.save()
//                        }
//                    }
//                }
//            }
        }
    }
}
