//
//  DeviceTouchPulseView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 13.03.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

class _DeviceTouchPulseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let pulsator = Pulsator()
        pulsator.radius = 50
        pulsator.numPulse = 6
        pulsator.backgroundColor = UIColor(red: 0.36, green: 0.61, blue: 0.97, alpha: 1).cgColor
        layer.addSublayer(pulsator)
        // pulsator.frame = .init(x: 100, y: 100, width: 50, height: 50)
        pulsator.start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DeviceTouchPulseView: UIViewRepresentable {
    typealias UIViewType = _DeviceTouchPulseView
    
    func makeUIView(context: Context) -> _DeviceTouchPulseView {
        _DeviceTouchPulseView(frame: .zero)
    }
    
    func updateUIView(_ uiView: _DeviceTouchPulseView, context: Context) {
        
    }
}
