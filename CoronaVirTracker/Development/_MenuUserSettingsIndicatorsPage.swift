//
//  _MenuUserSettingsIndicatorsPage.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 07.01.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

class _MenuUserSettingsIndicatorsState: ObservableObject {
    
    @Published var isLoading = false
    
    @Published var indicators: [RealmIndicator] = []
    
    func loadIndicators(for type: __HealthIndicatorType, option: Int) {
        if option == 0 {
            isLoading = true
            IndicatorManager.shared.getBulk(for: type) { indicators in
                DispatchQueue.main.async { [weak self] in
                    self?.indicators = indicators.map { $0.tpRealmModel() }
                    self?.isLoading = false
                }
            }
        } else {
            isLoading = false
            indicators = RealmIndicator.getIndicators(for: type)
                .sorted(by: { ind1, ind2 in
                    ind1.date > ind2.date
                })
        }
    }
    
    func eraseRealm(for type: __HealthIndicatorType) {
        indicators.removeAll()
        RealmIndicator.clear(type: type)
    }
}

struct _MenuUserSettingsIndicatorsItemView: View {
    
    let indicator: RealmIndicator
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(Int(indicator.value))")
                if indicator.additionalValue != nil && indicator.additionalValue != 0 {
                    Text("\(indicator.additionalValue!)")
                }
            }
            Spacer()
            Text(indicator.date.description)
        }
        .font(.system(size: 16))
    }
}

struct _MenuUserSettingsIndicatorsPage: View {
    
    let indicatorType: __HealthIndicatorType
    
    @ObservedObject var state = _MenuUserSettingsIndicatorsState()
    
    @State private var pickedOption = 0
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Picker("", selection: $pickedOption) {
                        Text("Server").tag(0)
                        Text("Realm").tag(1)
                    }
                    .pickerStyle(.segmented)
                    HStack {
                        Text("\(state.indicators.count) indicators")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        if state.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        if pickedOption == 1 {
                            Spacer()
                            Button {
                                state.eraseRealm(for: indicatorType)
                            } label: {
                                Text("Erase all")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .padding([.top, .bottom], 16)
            }
            .onChange(of: pickedOption) { newValue in
                state.loadIndicators(for: indicatorType, option: newValue)
            }
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(0..<state.indicators.count, id: \.self) { index in
                        _MenuUserSettingsIndicatorsItemView(indicator: state.indicators[index])
                    }
                }
            }
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            state.loadIndicators(for: indicatorType, option: 0)
        }
    }
}

final class _MenuUserSettingsIndicatorsController: UIHostingController<_MenuUserSettingsIndicatorsPage> {
    static func createInstance(for indicator: __HealthIndicatorType) -> UIViewController {
        let vc = _MenuUserSettingsIndicatorsController(rootView: .init(indicatorType: indicator))
        return vc
    }
}
