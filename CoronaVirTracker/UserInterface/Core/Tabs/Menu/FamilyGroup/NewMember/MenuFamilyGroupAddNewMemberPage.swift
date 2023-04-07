//
//  FamilyGroupAddNewMemberPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 11.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI
import PhoneNumberKit

struct FamilyGroupAddNewMemberPage: View {
    
    @State var isLoading = false
    
    // @ObservedObject var phoneField = FormField(validator: .phoneNumber, defaultValue: "+380")
    
    @State var number = PhoneNumber.notPhoneNumber()
    
    var onCancel: (() -> ())?
    
    var onCodeReceived: ((_ error: HandledErrorModel?) -> ())?
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ZStack {
                    ScrollView {
                        ZStack {
                            HStack {
                                Spacer()
                                Button {
                                    onCancel?()
                                } label: {
                                    Text(locStr("Cancel"))
                                        .foregroundColor(Color(Style.TextColors.mainRed))
                                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                                }
                            }
                            Text(locStr("Family access"))
                                .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                                .foregroundColor(Color(Style.TextColors.commonText))
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                        }
                        .padding()
                        
                        VStack(alignment: .center, spacing: 10) {
                            Text(locStr("Invitation to a family group"))
                                .font(CustomFonts.createInter(weight: .medium, size: 18))
                                .foregroundColor(Color(Style.TextColors.commonText))
                            
                            Text(locStr("Invite your loved ones to MISU to access each otherʼs health metrics"))
                                .font(CustomFonts.createInter(weight: .regular, size: 15))
                                .foregroundColor(Color(Style.TextColors.gray))
                                .multilineTextAlignment(.center)
                            
                            Color.clear
                                .frame(height: 10)
                            
                            VStack(alignment: .leading) {
                                Text(locStr("Phone number"))
                                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                                    .foregroundColor(Color(Style.TextColors.gray))
                                PhoneNumberContainer(number: $number)
                            }
                        }
                        .padding(16)
                        
                        Color.clear
                            .frame(height: 500)
                    }
                    
                    AppRedButtonTabView(title: locStr("Add")) {
                        invite()
                    }
                    
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
                .background(Color(red: 0.97, green: 0.98, blue: 1))
                .navigationBarHidden(true)
                .ignoresSafeArea(.all, edges: .bottom)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func invite() {
        isLoading = true
        let rawPhone = number.numberString
        FamilyGroupManager.shared.inviteToGroup(phoneNum: rawPhone) { error in
            onCodeReceived?(error)
            DispatchQueue.main.async {
                isLoading = false
            }
        }
    }
}

final class FamilyGroupAddNewMemberHostingController: UIHostingController<FamilyGroupAddNewMemberPage> {
    
    override init(rootView: FamilyGroupAddNewMemberPage) {
        super.init(rootView: rootView)
        self.rootView.onCodeReceived = { [weak self] error in
            self?.pushResultPage(error)
        }
        self.rootView.onCancel = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pushResultPage(_ error: HandledErrorModel?) {
        DispatchQueue.main.async { [weak self] in
            if let er = error {
                let vc = UIHostingController(
                    rootView: FailPage(
                        title: locStr("Error sending invitation"),
                        errorDescription: locStr(er.message)
                    )
                )
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = UIHostingController(
                    rootView: SuccessPage(
                        title: locStr("Request sent successfully!"),
                        description: locStr("The number owner has received your invitation to join MISU"))
                )
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    static func createInstance() -> UIViewController {
        let vc = FamilyGroupAddNewMemberHostingController(rootView: .init())
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
}
