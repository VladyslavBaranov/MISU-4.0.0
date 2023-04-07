//
//  CountrySelectionView.swift
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
    
    init(icon: String, country: String, id: String, isSelected: Bool) {
        self.icon = icon
        self.country = country
        self.id = id
        self.isSelected = isSelected
    }
}

private class CountrySelectionViewState: ObservableObject {
    var countries: [Country] = [
        .init(icon: "🇺🇦", country: "Україна", id: "ua", isSelected: true),
        .init(icon: "🇵🇱", country: "Польша", id: "pl", isSelected: false),
        .init(icon: "🏳️", country: "Інше", id: "null", isSelected: false)
    ]
    
    func toggle(_ country: Country) {
        KeyStore.saveValue(country.id, for: .userCountry)
        NotificationManager.shared.post(.didChangeUserCountry)
        for c in countries {
            c.isSelected = false
        }
        country.isSelected.toggle()
        objectWillChange.send()
    }
}

struct CountrySelectionView: View {
    
    @ObservedObject private var state = CountrySelectionViewState()
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Ваша країна\nвизначена правильно?")
                    .font(CustomFonts.createInter(weight: .medium, size: 16))
                Text("Оберіть де Ви проживаєте для правильного відображення Асистента. Ви завжди можете змінити країну: Профіль - Налаштування")
                    .font(CustomFonts.createInter(weight: .regular, size: 14))
            }
            .padding()
            Color(UIColor.systemGray6)
                .frame(height: 0.5)
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
        }
        
        .multilineTextAlignment(.center)
    }
}
