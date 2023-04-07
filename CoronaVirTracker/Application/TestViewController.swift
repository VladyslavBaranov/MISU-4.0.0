//
//  TestViewController.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 12.12.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

class PulseAnimation: CALayer {
    var animationDuration: TimeInterval = 1.5
    var radius: CGFloat = 100
    var numberOfPulses: Float = 10
}

struct RunningLabel: UIViewRepresentable {
    
    let text: String
    
    func makeUIView(context: Context) -> _RunningLabel {
        let label = _RunningLabel()
        label.setText(text)
        return label
    }
    
    func updateUIView(_ uiView: _RunningLabel, context: Context) {
        
    }
    
    typealias UIViewType = _RunningLabel
    
    
}

class _RunningLabel: UIView {
    
    var label1: UILabel!
    var label2: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label1 = UILabel()
        label1.textColor = .white
        label1.font = CustomFonts.createUIInter(weight: .bold, size: 20)
        addSubview(label1)
        
        label2 = UILabel()
        label2.textColor = .white
        label2.font = CustomFonts.createUIInter(weight: .bold, size: 20)
        addSubview(label2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let dim = self.label1.bounds.width
            UIView.animate(withDuration: 4, delay: 0, options: [.repeat, .curveLinear]) {
                self.label1.frame.origin.x = -dim
                self.label2.frame.origin.x = 0
            }
        }
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(resumeAnimations), name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label1.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.height)
        label2.frame = .init(x: bounds.width, y: 0, width: bounds.width, height: bounds.height)
    }
    
    func setText(_ string: String) {
        label1.text = string
        label2.text = string
    }
    
    @objc func resumeAnimations() {
        print("RESUME")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let dim = self.label1.bounds.width
            UIView.animate(withDuration: 4, delay: 0, options: [.repeat, .curveLinear]) {
                self.label1.frame.origin.x = -dim
                self.label2.frame.origin.x = 0
            }
        }
    }
}
 
class TestViewController: UIViewController {
    
    var label: _RunningLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pulsator = Pulsator()
        pulsator.radius = 50
        pulsator.numPulse = 3
        pulsator.backgroundColor = UIColor.blue.cgColor
        view.layer.addSublayer(pulsator)
        pulsator.frame = .init(x: 100, y: 100, width: 50, height: 50)
        pulsator.start()
        
        view.backgroundColor = .white
    }
    
}
