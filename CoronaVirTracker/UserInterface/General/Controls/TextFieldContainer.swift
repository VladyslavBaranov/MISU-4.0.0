//
//  TextFieldContainer.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 23.06.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct TextFieldContainer: View {
    
    @ObservedObject var formField: FormField

    enum Style {
        case plain, countrySelection, dropDown
    }
    
    let style: Style
    
    let title: String
    let subtitle: String?
    let placeHolder: String?
    var errorMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.412, green: 0.466, blue: 0.604))
            CustomTextField(formField: formField, style: style, placeHolder: placeHolder)
            if subtitle != nil {
                
                if formField.isValidated {
                    Text(subtitle!)
                        .font(.system(size: 14))
                        .foregroundColor(formField.isValidated ? Color(red: 0.412, green: 0.466, blue: 0.604) : .red)
                } else {
                    Text(errorMessage.isEmpty ? subtitle! : errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(formField.isValidated ? Color(red: 0.412, green: 0.466, blue: 0.604) : .red)
                }
                
            } else {
                if !formField.isValidated {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(formField.isValidated ? Color(red: 0.412, green: 0.466, blue: 0.604) : .red)
                }
            }
        }
    }
}
