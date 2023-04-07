//
//  RegistrationCodePage.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 25.07.2022.
//

import SwiftUI
import FirebaseAuth

class AuthCodeInputPageState: ObservableObject {
    
    var secondsLeft = 90
    @Published var timerString = "1 \(locStr("min")) 30 \(locStr("sec"))"
    
    @Published var isTimerRunning = false
    
    @Published var isLoading: Bool = false
    @Published var errorIsShown = false
    @Published var errorToShow: Error? = nil
    
    var number = ""
    var verficationID = ""
    
    var timer: Timer!
    
    func fireTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    func cancelTimer() {
        secondsLeft = 90
        timer.invalidate()
    }
    
    @objc func handleTimer() {
        if secondsLeft == 0 {
            secondsLeft = 90
            isTimerRunning = false
            timer.invalidate()
        }
        secondsLeft -= 1
        
        let mins = secondsLeft / 60
        let sec = secondsLeft % 60
        
        timerString = mins == 0 ? "\(sec) \(locStr("sec"))" : "\(mins) \(locStr("min")) \(sec) \(locStr("sec"))"
    }
}

struct AuthCodeInputPage: View {
    
    let targetPhoneNumber: String
    
    // @Environment(\.presentationMode) var mode
    
    @ObservedObject var state = AuthCodeInputPageState()
    
    var onDismiss: (() -> ())?
    var onCodeConfirmed: ((String) -> ())?
    
    @State private var isInvalidCode = false
    
    @State var code: [Character] = Array(repeating: " ", count: 6)
    @State var keyboardIsActive = false
    
    @State var didCompleteCode = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Color.clear
                            .frame(height: 120)
                        Text(locStr("Confirmation of registration"))
                            .font(CustomFonts.createInter(weight: .medium, size: 18))
                            .multilineTextAlignment(.center)
                        Text(locStr("The code was sent to the number"))
                            .font(CustomFonts.createInter(weight: .regular, size: 16))
                            .multilineTextAlignment(.center)
                        Text(targetPhoneNumber)
                            .font(CustomFonts.createInter(weight: .bold, size: 16))
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 0) {
                        ZStack {
                            HStack(spacing: 12) {
                                CodeCharacterView(code: .constant(String(code[0])))
                                CodeCharacterView(code: .constant(String(code[1])))
                                CodeCharacterView(code: .constant(String(code[2])))
                                CodeCharacterView(code: .constant(String(code[3])))
                                CodeCharacterView(code: .constant(String(code[4])))
                                CodeCharacterView(code: .constant(String(code[5])))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            HiddenTextField(contentLength: 6, code: $code, isActive: $keyboardIsActive, didCompleteCode: { completed in
                            })
                            .frame(height: 70)
                            .onTapGesture {
                                withAnimation {
                                    state.errorIsShown = false
                                    state.errorToShow = nil
                                }
                            }
                        }
                        
                        if state.errorIsShown, let error = state.errorToShow {
                            Text(error.localizedDescription)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .padding(.horizontal, 16)
                        }
                        
                        if isInvalidCode {
                            Text(locStr("Please check and try entering the code again, or click send code again"))
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .padding(.horizontal, 16)
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        if state.isTimerRunning {
                            VStack {
                                Text(locStr("You will be able to resend the code in:"))
                                    .font(CustomFonts.createInter(weight: .regular, size: 14))
                                Text(state.timerString)
                                    .font(CustomFonts.createInter(weight: .semiBold, size: 14))
                            }
                            .foregroundColor(Color(Style.TextColors.gray))
                        } else {
                            Button {
                                state.fireTimer()
                            } label: {
                                Text(locStr("Send the code again"))
                                    .foregroundColor(Color(Style.TextColors.mainRed))
                                    .font(CustomFonts.createInter(weight: .regular, size: 15))
                                    .underline()
                            }
                        }
                    }
                    .padding(.top, 5)
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            
            AppRedButtonTabView(title: locStr("Next")) {
                let code = self.code.reduce("") { partialResult, char in
                    return partialResult + String(char)
                }
                
                isInvalidCode = code.trimmingCharacters(in: .whitespaces).count < 6
                guard !isInvalidCode else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                
                state.isLoading = true
                onCodeConfirmed?(code)
            }
            
            VStack {
                Color.clear
                    .frame(height: 50)
                HStack {
                    Button {
                        onDismiss?()
                    } label: {
                        Image("orange_back")
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
            if state.isLoading {
                ZStack {
                    BlurView()
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            
//            if state.errorIsShown {
//                ZStack {
//                    BlurView()
//                        .frame(width: 90, height: 90)
//                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//                    Text("Error")
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(.gray)
//                }.onTapGesture {
//                    withAnimation {
//                        state.errorIsShown = false
//                    }
//                }
//            }
            
        }
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    func shouldDisableNextButton() -> Bool {
        let code = self.code.reduce("") { partialResult, char in
            return partialResult + String(char)
        }.trimmingCharacters(in: .whitespacesAndNewlines)
        return code.count < 6
    }
}

class AuthCodeInputPageHostingController: UIHostingController<AuthCodeInputPage> {
    
    var number = ""
    var verficationID = ""
    
    override init(rootView: AuthCodeInputPage) {
        super.init(rootView: rootView)
        self.rootView.onDismiss = { [weak self] in
            self?.dismissSelf()
        }
        self.rootView.onCodeConfirmed = { [weak self] code in
            self?.onCodeConfirmed(code)
        }
        view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissSelf() {
        // print("Back!")
        navigationController?.popViewController(animated: true)
    }
    
    func stopIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.state.isLoading = false
        }
    }
    
    func showError(_ error: Error? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.state.errorToShow = error
            self?.rootView.state.errorIsShown = true
        }
    }
    
    func onCodeConfirmed(_ code: String) {
        
        let credentials = PhoneAuthProvider.provider().credential(
            withVerificationID: verficationID,
            verificationCode: code
        )
        Auth.auth().signIn(with: credentials) { [weak self] authResult, error in
            if let _ = error {
                self?.stopIndicator()
                self?.showError(error)
                return
            }
            authResult?.user.getIDToken { token, error in
                if let token = token {
                    self?.login(token: token)
                } else {
                    self?.stopIndicator()
                }
            }
        }
    }
    
    func login(token: String) {
        AuthManagerV2.shared.signIn(number, token: token) { [weak self] token in
            guard let token = token else {
                self?.stopIndicator()
                self?.showError()
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                return
            }
            _ = KeychainUtility.saveCurrentUserToken(token)
            self?.checkUser()
        }
    }
    
    func checkUser() {
        AuthManagerV2.shared.checkUser(number) { [weak self] response in
            guard let response = response else {
                self?.stopIndicator()
                self?.showError()
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                return
            }
            if response.profile {
                self?.stopIndicator()
                IndicatorManager.shared.performServerDataImport()
                DispatchQueue.main.async {
                    self?.navigationController?.dismiss(animated: true)
                }
            } else {
                self?.stopIndicator()
                DispatchQueue.main.async {
                    self?.pushCreationMode()
                }
            }
        }
    }
    
    func pushCreationMode() {
        let vc = AuthUserTypeSelectionController(rootView: .init())
        vc.view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
        navigationController?.pushViewController(vc, animated: true)
    }
}
