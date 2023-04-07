//
//  RegistrationPage.swift
//  MISU-Test
//
//  Created by Vladyslav Baranov on 25.07.2022.
//

import SwiftUI
import WebKit
import FirebaseAuth
import PhoneNumberKit

final class WebViewController: UIViewController, WKNavigationDelegate {
    
    private var progressView: UIActivityIndicatorView!
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        progressView = UIActivityIndicatorView(style: .medium)
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.hidesWhenStopped = true
    }
    
    func load(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
        progressView.startAnimating()
        webView.alpha = 0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.webView.alpha = 1
        }
        progressView.stopAnimating()
    }
}

struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

final class AuthNumberInputState: ObservableObject {
    
    @Published var isLoading = false
    
    @Published var errorIsShown = false
    
}

struct AuthNumberInputPage: View {
    
    @State private var isInvalidNumber = false
    
    @State var webViewIsShown = false
    
    var onNextTapped: ((String) -> ())?
    var onShowPrivacy: (() -> ())?
    
    @State var number = PhoneNumber.notPhoneNumber()
    
    @ObservedObject var state = AuthNumberInputState()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    Color.clear
                        .frame(height: 50)
                    Image("RedLogo")
                        .resizable()
                        .frame(width: 55, height: 55, alignment: .center)
                        .padding(20)
                    Text(locStr("Enter a phone number"))
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .multilineTextAlignment(.center)
                    Text(locStr("We will send an SMS with a code to confirm the number"))
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                        .multilineTextAlignment(.center)
                    VStack(alignment: .leading) {
//                        Text("Номер телефона *")
//                            .font(.system(size: 14))
//                            .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
                        PhoneNumberContainer(number: $number)
                        if isInvalidNumber {
                            Text(locStr("Invalid number format. Enter again"))
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        }
                    }.padding(.top, 32)
                }
                .padding(.horizontal, 16)
                Button {
                    onShowPrivacy?()
                    // webViewIsShown.toggle()
                } label: {
                    makeConfirmButton()
                        .font(CustomFonts.createInter(weight: .regular, size: 14))
                }.padding(16)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            
            AppRedButtonTabView(title: locStr("Next")) {
                let numberKit = PhoneNumberKit()
                let e164 = numberKit.format(number, toType: .e164)
                
                guard numberKit.isValidPhoneNumber(e164) else {
                    isInvalidNumber = true
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                isInvalidNumber = false
                onNextTapped?(e164)
                state.isLoading = true
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
            
            if state.errorIsShown {
                ZStack {
                    BlurView()
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    Text("Error")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }.onTapGesture {
                    withAnimation {
                        state.errorIsShown = false
                    }
                }
            }
            
        }
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
    
    func shouldDisableNextButton() -> Bool {
        false // (phoneContainer.phoneField?.phoneNumber?.numberString.count ?? 0) < 5
    }
    
    private func makeConfirmButton() -> some View {
        Text(locStr("By clicking continue, you agree to the terms of"))
            .foregroundColor(Color(Style.TextColors.commonText))
        + Text(locStr(" the privacy policy"))
            .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.97))
            .underline()
    }
    
    func showError() {
        DispatchQueue.main.async {
            state.errorIsShown = true
        }
    }
}
 
class AuthNumberInputHostingController: UIHostingController<AuthNumberInputPage> {
    
    private var previousPhoneNumber = ""
    
    override init(rootView: AuthNumberInputPage) {
        super.init(rootView: rootView)
        self.rootView.onNextTapped = { [weak self] number in
            self?.pushCodeInput(number)
        }
        self.rootView.onShowPrivacy = { [weak self] in
            let vc = WebViewController()
            self?.present(vc, animated: true)
            vc.load(URL(string: "https://misu.in.ua/policy?tab=privacy")!)
        }
        view.backgroundColor = UIColor(red: 0.98, green: 0.99, blue: 1, alpha: 1)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pushCodeInput(_ number: String) {
        
        if previousPhoneNumber != number {
            
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(number, uiDelegate: nil) { [weak self] verificationID, error in
                    if let _ = error {
                        self?.rootView.state.isLoading = false
                        self?.rootView.showError()
                        return
                    }
                    if let verificationID = verificationID {
                        self?.rootView.state.isLoading = false
    
                        let page = AuthCodeInputPageHostingController(rootView: .init(targetPhoneNumber: number))
                        page.verficationID = verificationID
                        page.number = number
                        self?.navigationController?.pushViewController(page, animated: true)
                    } else {
                        self?.rootView.state.isLoading = false
                        self?.rootView.showError()
                    }
                }
        }
        
        previousPhoneNumber = number
        
    }
}
