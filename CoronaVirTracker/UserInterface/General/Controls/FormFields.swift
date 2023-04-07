//
//  FormFields.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 27.06.2022.
//

import Foundation
import Combine

class FormField: ObservableObject {
    
    enum Validator {
        case emptyCheck
        case date
        case phoneNumber
        case email
        case ipn
        case uaPassportSerial
    }
    
    var validator: Validator = .emptyCheck
    
    @Published var value: String = ""
    @Published var isValidated = true
    
    var onValueChange: ((String) -> ())?
    
    private var cancellable: AnyCancellable?
    
    init(validator: Validator) {
        self.validator = validator
        
        cancellable = $value
            .throttle(for: 1.2, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] str in
                self?.onValueChange?(str)
        }
    }
    
    convenience init(validator: Validator, defaultValue: String) {
        self.init(validator: validator)
        value = defaultValue
    }
    
    func validate() {
        switch validator {
        case .emptyCheck:
            if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                isValidated = false
            } else {
                isValidated = true
            }
        case .uaPassportSerial:
            isValidated = value.allSatisfy({ $0.isLetter }) && value.count == 2
        case .ipn:
            isValidated = value.range(of: #"^\d{10}$"#, options: .regularExpression, range: nil, locale: nil) != nil
        case .date:
            isValidated = value.range(of: #"\d\d\.\d\d\.\d\d\d\d"#, options: .regularExpression, range: nil, locale: nil) != nil
        case .email:
            isValidated = value.range(of: #"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"#, options: .regularExpression, range: nil, locale: nil) != nil
        case .phoneNumber:
            isValidated = value.removingWhitespacesAndBrackets().range(
                of: #"^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$"#,
                options: .regularExpression, range: nil, locale: nil) != nil
        }
    }
}

class DropDownFormField: FormField {
    @Published var list: [String] = []
    convenience init(validator: FormField.Validator, list: [String]) {
        self.init(validator: validator)
        self.list = list
    }
}
