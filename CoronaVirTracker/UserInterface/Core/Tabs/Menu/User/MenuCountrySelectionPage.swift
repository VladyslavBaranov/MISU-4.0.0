//
//  MenuCountrySelectionPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 26.01.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

private class Country {
    let icon: String
    let country: String
    let id: String
    var isSelected: Bool = false
    
    init(icon: String, country: String, id: String) {
        self.icon = icon
        self.country = country
        self.id = id
        
        if let country = KeyStore.getStringValue(for: .userCountry) {
            if country == id {
                self.isSelected = true
            }
        } else {
            self.isSelected = false
        }
    }
}

private class MenuCountrySelectionPageState: ObservableObject {
    var countries: [Country] = [
        .init(icon: "🇺🇦", country: "Україна", id: "ua"),
        .init(icon: "🇵🇱", country: "Польша", id: "pl"),
        .init(icon: "🏳️", country: "Інше", id: "null")
    ]
    
    func toggle(_ country: Country) {
        for c in countries {
            c.isSelected = false
        }
        country.isSelected.toggle()
        objectWillChange.send()
    }
    
    func getSelectedCountry() -> Country {
        countries.first { $0.isSelected }!
    }
    
    func save() {
        let country = getSelectedCountry()
        KeyStore.saveValue(country.id, for: .userCountry)
        NotificationManager.shared.post(.didChangeUserCountry)
    }
}

struct MenuCountrySelectionPage: View {
    
    @Environment(\.presentationMode) var mode
    
    @ObservedObject private var state = MenuCountrySelectionPageState()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Color.white
                .frame(height: 30)
            
            AppCancelSaveNavigationBar(title: "Вибір країни") {
                mode.wrappedValue.dismiss()
            } onSave: {
                state.save()
                mode.wrappedValue.dismiss()
            }
            .background(Color.white)
            
            VStack(spacing: 30) {
                ForEach(state.countries, id: \.id) { country in
                    HStack(spacing: 10) {
                        Image("round-check")
                            .opacity(country.isSelected ? 1 : 0)
                        Text(country.icon)
                        Text(country.country)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        state.toggle(country)
                    }
                }
            }
            .font(CustomFonts.createInter(weight: .regular, size: 14))
            .padding()
            
            Spacer()
        }
    }
}
