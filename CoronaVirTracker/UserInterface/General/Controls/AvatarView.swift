//
//  BlankImageFamilyCard.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 07.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct AvatarView: View {
    
    let user: UserModel?
    
    var body: some View {
        VStack {
            ZStack {
                
                Color.white
                    .frame(width: 90, height: 90, alignment: .center)
                    .cornerRadius(45)
                    .overlay(
                        Circle()
                            .stroke(Color(Style.Stroke.lightGray), lineWidth: 1)
                    )
                Text(getInitials())
                    .font(CustomFonts.createInter(weight: .bold, size: 23))
                    .foregroundColor(Color(Style.TextColors.commonText))
                
                if !getImageURL().isEmpty {
                    AsyncImage(isCurrentUser: isCurrentUser(), url: getImageURL())
                        .scaledToFit()
                        .frame(width: 90, height: 90, alignment: .center)
                        .scaledToFit()
                        .clipped()
                        .cornerRadius(45)
                        .overlay(
                            Circle()
                                .stroke(Color(Style.Stroke.lightGray), lineWidth: 1)
                        )
                }
            }
        }
    }
    
    private func isCurrentUser() -> Bool {
        user?.id == KeyStore.getIntValue(for: .currentUserId)
    }
    
    private func getInitials() -> String {
        guard let name = user?.profile?.name else { return "-" }
        let sep = name.split(separator: " ").map { $0.first }.compactMap { $0 }
        let sepStrings = sep.map { String($0) }
        return sepStrings.joined()
    }
    
    private func getUsername() -> String {
//        guard let name = user?.profile?.name else { return "--" }
//        let splitted = name.split(separator: " ")
//        return splitted.joined(separator: "\n")
        return user?.profile?.fullName ?? "--"
    }
    
    private func getImageURL() -> String {
        guard let url = user?.profile?.imageURL else {
            return ""
        }
        return "https://misu.pp.ua" + url
    }
}
