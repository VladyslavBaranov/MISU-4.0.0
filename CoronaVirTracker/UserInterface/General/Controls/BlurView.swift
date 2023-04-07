//
//  BlurView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 22.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
