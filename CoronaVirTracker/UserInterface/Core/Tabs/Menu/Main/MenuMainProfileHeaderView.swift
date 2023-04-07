//
//  MenuProfileHeaderView.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 12.07.2022.
//

import SwiftUI

private class MenuProfileHeaderViewState: ObservableObject {
	var user: UserModel!
	
	func update() {
        // user = RealmUser.getCurrent()?.profile
		// objectWillChange.send()
	}
}

struct MenuProfileHeaderView: View {
    
	@ObservedObject private var state = MenuProfileHeaderViewState()
	
	init(user: UserModel) {
		state.user = user
	}
    
    private func getUsername() -> String {
        state.user?.profile?.fullName ?? "--"
    }
    
    private func getBirthdate() -> String {
        guard let date = state.user?.profile?.birthdayDate else { return "--" }
        // guard let age = user.profile?.age else { return "--" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let string = formatter.string(from: date)
        
        let yearsInterval = abs(date.timeIntervalSince(Date()))
        let years = yearsInterval / (3600 * 24 * 365.25)
        
        return string + " (\(Int(years)) y.)"
    }
    
    private func getHeight() -> String {
        let height = state.user?.profile?.height ?? 0.0
        return String(Int(height))
    }
    
    private func getWeight() -> String {
        let weight = state.user?.profile?.weight ?? 0.0
        return String(Int(weight))
    }
    
    func getGender() -> String {
        let gender = state.user?.profile?.gender
        return gender?.localized.capitalized ?? "--"
    }
    

    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Color.clear
                    .frame(height: 50)
                Text(getUsername())
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .foregroundColor(Color(Style.TextColors.commonText))
                Text(getBirthdate())
                    .font(CustomFonts.createInter(weight: .regular, size: 16))
                    .foregroundColor(Color(Style.TextColors.gray))
                HStack {
                    VStack(alignment: .center, spacing: 10) {
                        Text(getGender())
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Text(locStr("Gender"))
                            .foregroundColor(Color(Style.TextColors.gray))
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center, spacing: 10) {
                        Text(getHeight())
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Text(locStr("Height (cm)"))
                            .foregroundColor(Color(Style.TextColors.gray))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center, spacing: 10) {
                        Text(getWeight())
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Text(locStr("Weight (kg)"))
                            .foregroundColor(Color(Style.TextColors.gray))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    /*
                    VStack(alignment: .center, spacing: 10) {
                        Text("--")
                            .foregroundColor(Color(Style.TextColors.commonText))
                        Text(locStr("mm_str_6"))
                            .foregroundColor(Color(Style.TextColors.gray))
                    }
                    .frame(maxWidth: .infinity)
                     */
                }
                .padding([.trailing, .leading], 16)
                .font(CustomFonts.createInter(weight: .regular, size: 16))
                Color.clear
                    .frame(height: 20)
            }
            
            VStack {
				//BlankImageFamilyCard(profile: state.profile, showsUsername: false)
                //    .offset(x: 0, y: -45)
            
                Spacer()
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 32)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .circular)
                .stroke(Color(Style.Stroke.lightGray), lineWidth: 1 )
                .background(Color.white.cornerRadius(14))
        )
        .padding()
		.onReceive(NotificationCenter.default.publisher(
			for: NotificationManager.shared.notificationName(for: .didUpdateCurrentUser))) { _ in
				state.update()
			}
    }
}
