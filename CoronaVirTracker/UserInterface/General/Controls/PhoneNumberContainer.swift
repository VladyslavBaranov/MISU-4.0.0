//
//  CustomPhoneNumberTF.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 13.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import PhoneNumberKit
import SwiftUI

fileprivate struct _PhoneNumberTextField: UIViewRepresentable {
    typealias UIViewType = PhoneNumberTextField
    
    class Coordinator {
        var parent: _PhoneNumberTextField
        init(parent: _PhoneNumberTextField) {
            self.parent = parent
        }
        @objc func didChange(_ field: PhoneNumberTextField) {
            parent.phoneNumber = field.phoneNumber ?? .notPhoneNumber()
        }
        
        func setup(_ field: PhoneNumberTextField) {
            field.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        }
    }
    
    @Binding var country: CountryCodePickerViewController.Country
    @Binding var phoneNumber: PhoneNumber
    let textField = PhoneNumberTextField()
 
    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        context.coordinator.setup(textField)
        return textField
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
        view.text = ""
        view.countryCodePickerViewControllerDidPickCountry(country)
        view.updatePlaceholder()
    }
}

struct ContryPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    let didPickContry: (CountryCodePickerViewController.Country) -> ()
    
    class Coordinator: CountryCodePickerDelegate {
        
        var parent: ContryPicker
        
        init(parent: ContryPicker) {
            self.parent = parent
        }
        
        func countryCodePickerViewControllerDidPickCountry(_ country: CountryCodePickerViewController.Country) {
            parent.didPickContry(country)
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeUIViewController(context: Context) -> CountryCodePickerViewController {
        let controller = CountryCodePickerViewController(phoneNumberKit: .init())
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CountryCodePickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    typealias UIViewControllerType = CountryCodePickerViewController
    
}


struct PhoneNumberContainer: View {
    
    @Binding var number: PhoneNumber
    
    @State var pickerIsPresented = false
    @State var country = CountryCodePickerViewController.Country(for: "UA", with: .init())!
    
    @State var isActive = false
    
    var body: some View {
       ZStack {
           RoundedRectangle(cornerRadius: 8, style: .circular)
               .stroke(Color.gray, lineWidth: 0.3)
               .frame(height: 50)
           HStack {
               Button {
                   pickerIsPresented.toggle()
               } label: {
                   Text("\(country.flag)")
               }
               _PhoneNumberTextField(country: $country, phoneNumber: $number)
           }
           .padding([.leading, .trailing], 10)
           .sheet(isPresented: $pickerIsPresented) {
               ContryPicker { country in
                   self.country = country
               }
           }
       }
   }
}
