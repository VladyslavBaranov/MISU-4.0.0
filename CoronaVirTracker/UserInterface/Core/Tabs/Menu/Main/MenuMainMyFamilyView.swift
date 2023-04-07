//
//  MenuMyFamilyView.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 11.07.2022.
//

import SwiftUI

struct MenuMyFamilyView: View {
    
    let showsMore: Bool
    
    @ObservedObject var groupState = FamilyGroupManager.shared
    
//    @State var isAdmin: Bool
//    @State var groupMembers: [UserModel]
//    @State var user: UserModel?
//    @State var groupModel: GroupModel?
    
    var onMoreTapped: (() -> ())?
    var userTapped: ((UserModel) -> ())?
    var onNewTapped: (() -> ())?
    var onLongPress: ((UserModel) -> ())?
    
    private func getUsername(_ user: UserModel?) -> String {
        guard let name = user?.profile?.name else { return "--" }
        let splitted = name.split(separator: " ")
        return splitted.joined(separator: "\n")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Text(locStr("My family"))
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .foregroundColor(Color(Style.TextColors.commonText))
                Text("(\(groupState.group?.members.count ?? 0))")
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .foregroundColor(Color(Style.TextColors.gray))
                
                Spacer()
                if showsMore {
                    Button {
                        onMoreTapped?()
                    } label: {
                        HStack {
                            Text(locStr("More"))
                            Image(systemName: "chevron.right")
                        }
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                        .foregroundColor(Color(Style.TextColors.mainRed))
                    }
                }
                
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
                                onNewTapped?()
                            }
                        }
                        
                        if !(groupState.group?.members.isEmpty ?? true) {
                            ForEach(
                                groupState.group?.members ?? [],
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
                                    userTapped?(member)
                                }
                                .onLongPressGesture {
                                    guard member.id != KeyStore.getIntValue(for: .currentUserId) else { return }
                                    onLongPress?(member)
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

