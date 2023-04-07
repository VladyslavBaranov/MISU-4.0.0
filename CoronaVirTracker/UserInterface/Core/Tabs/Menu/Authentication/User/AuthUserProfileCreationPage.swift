//
//  RegistrationCompletedPage.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 25.07.2022.
//

import SwiftUI

struct AuthUserProfileCreationPage: View {
    
    @Environment(\.presentationMode) var mode
    
    @ObservedObject var firstName = FormField(validator: .emptyCheck)
    @ObservedObject var lastName = FormField(validator: .emptyCheck)
    @ObservedObject var patronymic = FormField(validator: .emptyCheck)
    @ObservedObject var birthdateField = FormField(validator: .date)
    
    @State var gender: Gender = .female
    
    @State var isUploadingProfile = false
    @State private var isError:  HandledErrorModel? = nil
    
    var onUploadingCompleted: (() -> ())?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        Image("RedLogo")
                            .resizable()
                            .frame(width: 55, height: 55, alignment: .center)
                            .padding(20)
                        Text(locStr("Completion of registration"))
                            .font(CustomFonts.createInter(weight: .medium, size: 18))
                            .multilineTextAlignment(.center)
                        Text(locStr("Enter your general details to complete the registration process *"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .multilineTextAlignment(.center)
                        if let error = isError {
                            Text(locStr(error.message))
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .padding(16)
                        }
                        
                        Color.clear
                            .frame(height: 10)
                        
                        VStack {
                            
                            TextFieldContainer(
                                formField: lastName,
                                style: .plain,
                                title: locStr("Second name"),
                                subtitle: nil,
                                placeHolder: nil,
                                errorMessage: locStr("Please enter full last name")
                            )
                            TextFieldContainer(
                                formField: firstName,
                                style: .plain,
                                title: locStr("First name"),
                                subtitle: nil,
                                placeHolder: nil,
                                errorMessage: locStr("Please enter full first name")
                            )
                            TextFieldContainer(
                                formField: patronymic,
                                style: .plain,
                                title: locStr("Father's name"),
                                subtitle: nil,
                                placeHolder: nil,
                                errorMessage: locStr("Please enter full your father name")
                            )
                            Color.clear
                                .frame(height: 10)
                            TextFieldContainer(
                                formField: birthdateField,
                                style: .plain,
                                title: locStr("Date of birth *"),
                                subtitle: nil,
                                placeHolder: locStr("DD.MM.YYYY"),
                                errorMessage: locStr("Invalid date format. Please enter again")
                            )
                            Color.clear
                                .frame(height: 10)
                            VStack(alignment: .leading) {
                                Text(locStr("Gender"))
                                    .foregroundColor(Color(Style.TextColors.gray))
                                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .circular)
                                        .stroke(Color(white: 0.8), lineWidth: 0.3)
                                        .background(RoundedRectangle(cornerRadius: 8, style: .circular).fill(.white))
                                        .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        
                                        HStack {
                                            Text(locStr("Female"))
                                                .foregroundColor(Color(Style.TextColors.commonText))
                                                .font(CustomFonts.createInter(weight: .regular, size: 15))
                                            Spacer()
                                            Image(gender == .female ? "reg_option_sel" : "reg_option")
                                        }
                                        .frame(height: 50)
                                        .padding([.leading, .trailing], 16)
                                        .onTapGesture {
                                            gender = .female
                                        }
                                        Color(white: 0.8)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 0.5)
                                            .padding([.leading, .trailing], 16)
                                        HStack {
                                            Text(locStr("Male"))
                                                .foregroundColor(Color(Style.TextColors.commonText))
                                                .font(CustomFonts.createInter(weight: .regular, size: 15))
                                            Spacer()
                                            Image(gender == .male ? "reg_option_sel" : "reg_option")
                                        }
                                        .frame(height: 50)
                                        .padding([.leading, .trailing], 16)
                                        .onTapGesture {
                                            gender = .male
                                        }
                                    }
                                }
                                Color.clear
                                    .frame(height: 20)
                                Text(locStr("* All fields are mandatory"))
                                    .foregroundColor(Color(Style.TextColors.gray))
                                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                            }
                            
                        }
                        .padding(16)
                        Color.clear
                            .frame(height: 160)
                        
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                
                AppRedButtonTabView(title: locStr("Done")) {
                    tryCreateProfile()
                }
                
                if isUploadingProfile {
                    ZStack {
                        BlurView()
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
            .background(Color(red: 0.98, green: 0.99, blue: 1))
        }
        .navigationBarHidden(true)
    }
    
    private func shouldDisableNextButton() -> Bool {
        firstName.value.isEmpty || lastName.value.isEmpty || patronymic.value.isEmpty || birthdateField.value.isEmpty
    }
    
    private func tryCreateProfile() {
        isUploadingProfile = true

        firstName.validate()
        lastName.validate()
        birthdateField.validate()
        
        guard firstName.isValidated && lastName.isValidated && birthdateField.isValidated
        else {
            isUploadingProfile = false
            return
        }
        
        let model = UserCardModel(
            name: firstName.value,
            second_name: lastName.value,
            family_name: patronymic.value,
            birthdayDate: birthdateField.value.toDateOnly(withFormat: "dd.MM.yyyy"),
            gender: gender)
        
        UserManager.shared.createProfile(profile: model) { result, error in
            isUploadingProfile = false
            
            if let _ = result {
                // Here we can parse user data if needed
                DispatchQueue.main.async {
                    onUploadingCompleted?()
                }
            }
            
            if let err = error {
                // Need to show error
                DispatchQueue.main.async {
                    isError = err
                }
            }
        }
    }
}

final class AuthUserProfileCreationController: UIHostingController<AuthUserProfileCreationPage> {
    
    override init(rootView: AuthUserProfileCreationPage) {
        super.init(rootView: rootView)
        self.rootView.onUploadingCompleted = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
        view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
