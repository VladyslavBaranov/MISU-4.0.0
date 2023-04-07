//
//  SubsriptionFeatureView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 10.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

struct SubscriptionFeature {
    let image: String
    let title: String
    let description: String
    let colors: [Color]
    let tag: Int
    
    static func createFeatures() -> [SubscriptionFeature] {
        [
            .init(
                image: "sub-pic-1",
                title: "Статус верифікації",
                description: "Пріоритетність у списку серед пацієнтів лікаря, швидша відповідь та отримання переліку послуг",
                colors: [
                    Color(red: 0.429, green: 0.483, blue: 1),
                    Color(red: 0.562, green: 0.606, blue: 1)
                ], tag: 0
            ),
            .init(
                image: "sub-pic-2",
                title: "Медичні історії",
                description: "MISU Щодня готуватиме Вам історію здоровʼя вас та ваших рідних в тому числі у порівнянні з іншими",
                colors: [
                    Color(red: 0.31, green: 0.495, blue: 0.967),
                    Color(red: 0.5, green: 0.641, blue: 1)
                ], tag: 1
            ),
            .init(
                image: "sub-pic-3",
                title: "Сімейний лікар",
                description: "Лікар для всієї групи, проконсультує, надасть рекомендації",
                colors: [
                    Color(red: 0.31, green: 0.67, blue: 1),
                    Color(red: 0.51, green: 0.77, blue: 1)
                ], tag: 2
            ),
            .init(
                image: "sub-pic-4",
                title: "Аналіз роботи серцево-судинної системи",
                description: "Детальні звіти по стану роботи серця",
                colors: [
                    Color(red: 0.31, green: 0.88, blue: 1),
                    Color(red: 0.62, green: 0.85, blue: 0.9)
                ], tag: 3
            ),
            .init(
                image: "sub-pic-5",
                title: "Звіти здоровʼя",
                description: "За допомогою машинного, штучний інтелект підготує для вас обʼєктивний огляд ваших показників здоров’я",
                colors: [
                    Color(red: 0.39, green: 0.44, blue: 0.93),
                    Color(red: 0.53, green: 0.57, blue: 0.95)
                ], tag: 4
            ),
            .init(
                image: "sub-pic-6",
                title: "10 користувачів",
                description: "Можна додати 10 членів родини в 1 групу",
                colors: [
                    Color(red: 0.26, green: 0.25, blue: 0.83),
                    Color(red: 0.46, green: 0.45, blue: 1)
                ], tag: 5
            ),
            .init(
                image: "sub-pic-7",
                title: "Сповіщення ризиків",
                description: "MISU Сповістить Вас ще до критичної ситуації, якщо так станеться з кимось з ваших рідних",
                colors: [
                    Color(red: 1, green: 0.5, blue: 0.53),
                    Color(red: 1, green: 0.41, blue: 0.44)
                ], tag: 6
            ),
            .init(
                image: "sub-pic-8",
                title: "Ментальне здоровʼя",
                description: "MISU підготує вам комплексне рішення по самодіагностиці стресових станів, дасть рекомендації та по потребі негайно зв’яже вас з лікарем",
                colors: [
                    Color(red: 0.31, green: 0.57, blue: 1),
                    Color(red: 0.51, green: 0.77, blue: 1)
                ], tag: 7
            ),
        ]
    }
}

struct SubsriptionFeatureView: View {
    
    let feature: SubscriptionFeature

    var body: some View {
        ZStack {
            LinearGradient(
                colors: feature.colors,
                startPoint: .bottomTrailing,
                endPoint: .topLeading
            )
            VStack(spacing: 10) {
                Image(feature.image)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(16)
                Text(feature.title)
                    .font(CustomFonts.createInter(weight: .bold, size: 22))
                    .multilineTextAlignment(.center)
                Text(feature.description)
                    .padding([.leading, .trailing], 20)
                    .multilineTextAlignment(.center)
                    .font(CustomFonts.createInter(weight: .regular, size: 14))
            }
            .foregroundColor(.white)
        }
        .cornerRadius(16)
    }
}
 
