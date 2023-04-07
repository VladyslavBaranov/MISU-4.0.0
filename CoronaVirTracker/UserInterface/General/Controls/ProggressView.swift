//
//  ProggressView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 12.12.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

class ProggressUIView: UIView {
    
    var proggressLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        proggressLine = UIView()
        proggressLine.backgroundColor = UIColor(red: 0.36, green: 0.61, blue: 0.97, alpha: 1)
        addSubview(proggressLine)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        proggressLine.layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ProggressView: UIViewRepresentable {
    
    @Binding var proggress: Int
    
    func updateUIView(_ uiView: ProggressUIView, context: Context) {
        let float = CGFloat(proggress) / 100
        UIView.animate(withDuration: 0.3) { [unowned uiView] in
            uiView.proggressLine.frame.size = .init(
                width: float * uiView.bounds.width,
                height: 16)
        }
    }
    
    typealias UIViewType = ProggressUIView
    
    func makeUIView(context: Context) -> ProggressUIView {
        let view = ProggressUIView()
        return view
    }
}
