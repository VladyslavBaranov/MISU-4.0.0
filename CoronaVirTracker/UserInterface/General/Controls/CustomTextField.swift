//
//  CustomTextField.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 23.06.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

fileprivate struct _CustomTextField: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    let style: TextFieldContainer.Style
    let placeholder: String
    @Binding var text: String
    @Binding var isActive: Bool
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var parent: _CustomTextField
        
        init(_ parent: _CustomTextField) {
            self.parent = parent
        }
        
        func setupTextField(_ uiTextField: UITextField) {
            uiTextField.addTarget(
                self, action: #selector(textFieldDidChange(_:)), for: .editingChanged
            )
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.text = textField.text ?? ""
            parent.isActive = false
            parent.text = textField.text ?? ""
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isActive = true
        }
        @objc func textFieldDidChange(_ sender: UITextField) {
            parent.text = sender.text ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.textColor = Style.TextColors.commonText
        textField.placeholder = placeholder
        textField.font = CustomFonts.createUIInter(weight: .regular, size: 16)
        textField.delegate = context.coordinator
        context.coordinator.setupTextField(textField)
        if style == .countrySelection {
            textField.keyboardType = .numberPad
        }
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

struct CustomTextField: View {
    
    @ObservedObject var formField: FormField
    let style: TextFieldContainer.Style
    let placeHolder: String?
    
    @State var isActive = false
    
    private func getText() -> String {
        if style == .countrySelection {
            return String.format(with: "+XXX (XX) XXX XX XX", phone: formField.value)
        }
        return formField.value
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .circular)
                .stroke(isActive ? Color(Style.Stroke.blue) : Color(white: 0.8), lineWidth: isActive ? 1 : 0.3)
                .background(RoundedRectangle(cornerRadius: 8, style: .circular).fill(.white))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            _CustomTextField(
                style: style,
                placeholder: placeHolder ?? "",
                text: $formField.value,
                isActive: $isActive
            )
            .onChange(of: formField.value) { newValue in
                formField.value = getText()
            }
            .padding(EdgeInsets(top: 0, leading: style == .countrySelection ? 70 : 15, bottom: 0, trailing: 15))
            
            /*
            TextField(placeHolder ?? "", text: $formField.value)
                .font(.system(size: 16))
                .onChange(of: formField.value) { newValue in
                    formField.value = getText()
                }
                .padding(EdgeInsets(top: 0, leading: style == .countrySelection ? 70 : 15, bottom: 0, trailing: 15))
             */
            if !formField.isValidated {
                HStack {
                    Spacer()
                    if style == .plain {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(.red)
                            .font(.system(size: 22))
                            .padding(.trailing, 10)
                    } else if style == .dropDown {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                            .padding(.trailing, 10)
                    }
                }
            }
            
            if style == .countrySelection {
                HStack {
                    Menu {
                        Button {
                            formField.value = "+380"
                        } label: {
                            Label("Україна", image: "Ukraine")
                        }
                        Button {
                            formField.value = "+48"
                        } label: {
                            Label("Polska", image: "Poland")
                        }
                    } label: {
                        Group {
                            Color.clear
                                .frame(width: 10)
                            Image("ua")
                                .resizable()
                                .frame(width: 18, height: 13)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}
