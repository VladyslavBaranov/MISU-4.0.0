//
//  NumberActivationPage.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 06.07.2022.
//

import SwiftUI

struct HiddenTextField: UIViewRepresentable {
    
    let contentLength: Int
    @Binding var code: [Character]
    @Binding var isActive: Bool
    
    var didCompleteCode: ((Bool) -> ())?
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var parent: HiddenTextField
        
        init(parent: HiddenTextField) {
            self.parent = parent
            
        }
        
        func setupTextField(_ uiTextField: UITextField) {
            uiTextField.addTarget(
                self, action: #selector(textFieldDidChange(_:)), for: .editingChanged
            )
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = parent.contentLength
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
        }
        
        @objc func textFieldDidChange(_ sender: UITextField) {
            if let text = sender.text {
                let characters = text.map { $0 }
                
                var code: [Character] = Array(repeating: " ", count: parent.contentLength)
                for i in 0..<characters.count {
                    code[i] = characters[i]
                }
                parent.code = code
                
                parent.didCompleteCode?(text.count == parent.contentLength)
                
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        
        textField.textContentType = .telephoneNumber
        textField.backgroundColor = .clear
        textField.keyboardType = .phonePad
        textField.textColor = .clear
        textField.tintColor = .clear
        textField.delegate = context.coordinator
        context.coordinator.setupTextField(textField)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if isActive {
            uiView.becomeFirstResponder()
        }
    }
    
    typealias UIViewType = UITextField
}

struct CodeCharacterView: View {
    
    @Binding var code: String
    
    var body: some View {
        Text(code)
            .font(CustomFonts.createInter(weight: .regular, size: 15))
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(Color.white.cornerRadius(12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        code.trimmingCharacters(in: .whitespaces).isEmpty ? Color(Style.Stroke.lightGray) : Color.blue,
                        lineWidth: 0.7
                    )
            )
    }
}

struct NumberActivationPage: View {
    
    @State var code: [Character] = [" ", " ", " ", " "]
    @State var keyboardIsActive = false
    
    @State var didCompleteCode = false
    
    var didCompleteActivation: (() -> ())?
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Активація\nАсистента")
                    .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                    .foregroundColor(Color(Style.TextColors.commonText))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(30)
                
                VStack(spacing: 8) {
                    
                    Text("Завершення активації")
                        .font(CustomFonts.createInter(weight: .medium, size: 18))
                        .foregroundColor(Color(Style.TextColors.commonText))
                    Text("Залишився підпис договору\nдобровільного медичного страхування")
                        .multilineTextAlignment(.center)
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                        .foregroundColor(Color(Style.TextColors.commonText))
                        .lineLimit(2)
                    
                    Color.clear
                        .frame(height: 20)
                    
                    Text("Введіть код, отриманий на номер:")
                        .multilineTextAlignment(.center)
                        .font(CustomFonts.createInter(weight: .regular, size: 16))
                        .foregroundColor(Color(Style.TextColors.commonText))
                    
                    Text("\(AssistantActivationState.shared.generalData.phoneNumber)")
                        .multilineTextAlignment(.center)
                        .font(CustomFonts.createInter(weight: .semiBold, size: 16))
                        .foregroundColor(Color(Style.TextColors.commonText))
                    
                    Color.clear
                        .frame(height: 10)
                    
                    ZStack {
                        HStack(spacing: 12) {
                            CodeCharacterView(code: .constant(String(code[0])))
                            CodeCharacterView(code: .constant(String(code[1])))
                            CodeCharacterView(code: .constant(String(code[2])))
                            CodeCharacterView(code: .constant(String(code[3])))
                        }
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .trailing], 50)
                        
                        HiddenTextField(contentLength: 4, code: $code, isActive: $keyboardIsActive, didCompleteCode: { completed in
                            didCompleteCode = completed
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                                didCompleteActivation?()
                            }
                        })
                        .frame(height: 70)
                        
                    }
                }
                
                Color.clear
                    .frame(height: 15)
                
                if didCompleteCode {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Button {
                        AssistantManager.shared.activate(AssistantActivationState.shared.toServerModel())
                    } label: {
                        Text("Надіслати код ще раз")
                            .font(CustomFonts.createInter(weight: .regular, size: 15))
                            .foregroundColor(Color(Style.TextColors.mainRed))
                            .underline()
                    }
                }
               

                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.98, green: 0.98, blue: 1))
        .onAppear {
            keyboardIsActive = true
        }
        .onChange(of: didCompleteCode) { newValue in
            if newValue {
                let phone = AssistantActivationState.shared.generalData.phoneNumber
                let code = self.code.map { String($0) }.joined()
                AssistantManager.shared.confirmCode(code, phone: phone)
                didCompleteActivation?()
            }
        }
    }
    
    func getCharacter(at index: Int) -> String {
        if code.count < index + 1 {
            return ""
        }
        return String(code[index])
    }
}

protocol NumberActivationHostingControllerDelegate: AnyObject {
    func shouldPushToCompletedView()
}

final class NumberActivationHostingController: UIHostingController<NumberActivationPage> {
    
    weak var delegate: NumberActivationHostingControllerDelegate?
    
    override init(rootView: NumberActivationPage) {
        super.init(rootView: rootView)
        self.rootView.didCompleteActivation = didCompleteActivation
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didCompleteActivation() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.shouldPushToCompletedView()
        }
    }
}
