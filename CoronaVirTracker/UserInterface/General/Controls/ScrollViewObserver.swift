//
//  ScrollViewObserver.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 29.06.2022.
//

import SwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

struct OffsettableScrollView<T: View>: View {
    let axes: Axis.Set
    let showsIndicator: Bool
    let onOffsetChanged: (CGPoint) -> Void
    let content: T
    
    init(axes: Axis.Set = .vertical,
         showsIndicator: Bool = true,
         onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
         @ViewBuilder content: () -> T
    ) {
        self.axes = axes
        self.showsIndicator = showsIndicator
        self.onOffsetChanged = onOffsetChanged
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicator) {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(
                        in: .named("ScrollViewOrigin")
                    ).origin
                )
            }
            .frame(width: 0, height: 0)
            content
        }
        .coordinateSpace(name: "ScrollViewOrigin")
        .onPreferenceChange(OffsetPreferenceKey.self,
                            perform: onOffsetChanged)
    }
}

class ScrollViewObserver: ObservableObject {
    @Published var didToggleState: Bool = false
    
    var isFixed = true
    var yOffset: CGFloat = 0.0 {
        didSet {
            if yOffset < -500 {
                isFixed = false
            } else {
                isFixed = false
            }
            
            if !isFixed {
                didToggleState = true
                isFixed = true
                didToggleState = false
            }
        }
    }
}
