//
//  SettingsPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 01.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct SettingsItem {
    var iconName: String
    var text: String
    var requiresChevron: Bool = true
    var isTest = false
}

struct SettingsPageItemCard: View {
    
    let item: SettingsItem
    
    var body: some View {
        HStack {
            if item.isTest {
                Text("T")
                    .font(.system(size: 20, weight: .semibold))
            } else {
                ZStack {
                    Image(item.iconName)
                }.frame(width: 40)
            }
            Text(item.text)
                .foregroundColor(Color(Style.TextColors.commonText))
                .font(CustomFonts.createInter(weight: .regular, size: 15))
            Spacer()
            if item.requiresChevron {
                Image("SChevron")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
        }
        .frame(height: 60)
        .contentShape(Rectangle())
    }
}

struct SettingsPage: View {
    
    let user: RealmUserModel?
    
    private let items: [SettingsItem] = [
        .init(iconName: "profile_s_icon", text: locStr("User profile")),
        .init(iconName: "lang_s_icon", text: locStr("Language change")),
        .init(iconName: "country-selection", text: "Вибір країни"),
        .init(iconName: "help_s_icon", text: locStr("Help")),
        .init(iconName: "logout_s_icon", text: locStr("Sign out of your account"), requiresChevron: false)
    ]
    
    @Environment(\.presentationMode) var mode
	
	@State var isLoading = false
    
    var onProfileTapped: ((RealmUserModel?) -> ())?
    
    var onSelectCountry: (() -> ())?
    
    var onMailTapped: (() -> ())?
	
	var didPerformLogout: (() -> ())?
    
    // MARK: Development only
    @State var xOffset: CGFloat = 0
    
    var body: some View {
        
		ZStack {
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
					}
					Text(locStr("Settings"))
						.font(CustomFonts.createInter(weight: .semiBold, size: 16))
				}
				.padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
				.background(Color.white)
                .foregroundColor(.black)
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0..<items.count, id: \.self) { index in
                            SettingsPageItemCard(item: items[index])
                                .onTapGesture {
                                    switch index {
                                    case 0:
                                        onProfileTapped?(user)
                                        break
                                    case 1:
                                        guard let url = URL(string: UIApplication.openSettingsURLString) else {
                                            return
                                        }
                                        guard UIApplication.shared.canOpenURL(url) else { return }
                                        UIApplication.shared.open(url)
                                    case 2:
                                        onSelectCountry?()
                                    case 3:
                                        onMailTapped?()
                                    case 4:
                                        isLoading = true
                                        performLogout()
                                    default:
                                        break
                                    }
                                }
                            if index != 4 {
                                Color(red: 0.89, green: 0.94, blue: 1)
                                    .frame(height: 0.7)
                            }
                        }
                        
                    }
                    .padding([.leading, .trailing], 16)
                    
                    if AppConfiguration.developmentModeEnabled {
                        Color.clear
                            .frame(height: 50)
                        GeometryReader { geometry in
                            let size = geometry.size.width / 4
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    
                                    Text("DEVELOPMENT FUNCTIONS")
                                        .frame(width: geometry.size.width)
                                    Text("TO BE REMOVED ON RELEASE")
                                        .frame(width: geometry.size.width)
                                    Text("DEVELOPMENT FUNCTIONS")
                                        .frame(width: geometry.size.width)
                                    
                                }
                                .offset(x: xOffset, y: 0)
                                .foregroundColor(.black)
                                .font(CustomFonts.createInter(weight: .bold, size: 20))
                            }
                            .background(Color.yellow)
                            .disabled(true)
                            .onAppear {
                                withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                                    xOffset = -size * 8
                                }
                            }
                        }
                        
                        VStack(spacing: 0) {
                            Group {
                                SettingsPageItemCard(item: .init(iconName: "", text: "Heart Indicators", isTest: true))
                                    .onTapGesture {
                                        NotificationManager.shared.post(.willBeginTestableAction, object: TestableAction.heartList)
                                    }
                                SettingsPageItemCard(item: .init(iconName: "", text: "Pressure Indicators", isTest: true))
                                    .onTapGesture {
                                        NotificationManager.shared.post(.willBeginTestableAction, object: TestableAction.pressureList)
                                    }
                                SettingsPageItemCard(item: .init(iconName: "", text: "Oxygen Indicators", isTest: true))
                                    .onTapGesture {
                                        NotificationManager.shared.post(.willBeginTestableAction, object: TestableAction.oxygenList)
                                    }
                                SettingsPageItemCard(item: .init(iconName: "", text: "Temperature Indicators", isTest: true))
                                    .onTapGesture {
                                        NotificationManager.shared.post(.willBeginTestableAction, object: TestableAction.tempreatureList)
                                    }
                            }
                            VStack(spacing: 16) {
                                Button {
                                    NotificationManager.shared.post(.willBeginTestableAction, object: TestableAction.shouldDisplayAssistanceWelcome)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                                            .fill(Color.blue.opacity(0.15))
                                            .frame(height: 50)
                                        Text("Display Assitance Welcome")
                                    }
                                }
                                Button {
                                    NotificationManager.shared.post(.willBeginTestableAction, object: TestableAction.clearChats)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                                            .fill(Color.red.opacity(0.15))
                                            .frame(height: 50)
                                        Text("Clear chats")
                                            .foregroundColor(.red)
                                    }
                                }
                                Button {
                                    NotificationManager.shared.post(.willBeginTestableAction, object: TestableAction.getAPIResponse)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                                            .fill(Color.green.opacity(0.15))
                                            .frame(height: 50)
                                        Text("GET")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            Color.clear
                                .frame(height: 100)
                        }
                        .padding([.leading, .trailing, .top], 16)
                        
                    }
                }
                .listStyle(PlainListStyle())
			}
			.navigationBarHidden(true)
			.ignoresSafeArea()
			
			if isLoading {
				ZStack {
					BlurView()
						.frame(width: 90, height: 90)
						.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
					ProgressView()
						.progressViewStyle(.circular)
				}
			}
		}
    }
    
    private func performLogout() {
        AuthManager.shared.logout { success, error in
            DispatchQueue.main.async {
                didPerformLogout?()
                LocalDataManager.shared.performLogoutClearup()
                
                WatchConnectionManager.shared.performLogoutClearup()
                
                NotificationManager.shared.post(.didLogout)
            }
        }
    }
}

