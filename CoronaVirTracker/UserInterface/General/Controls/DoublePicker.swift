//
//  DoublePicker.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 23.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import SwiftUI

protocol _DoublePickerViewDelegate: AnyObject {
    func didSelectRow(_ row: Int, tag: Int)
}

class _DoublePickerView: UIView {
    
    private var picker1: UIPickerView!
    private var picker2: UIPickerView!
    
    weak var delegate: _DoublePickerViewDelegate!
    
    let range = Array(stride(from: 0, through: 300, by: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        picker1.frame = .init(x: 0, y: 0, width: bounds.width / 2, height: bounds.height)
        picker2.frame = .init(x: bounds.width / 2, y: 0, width: bounds.width / 2, height: bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        picker1 = UIPickerView(frame: .zero)
        picker1.tag = 0
        picker1.dataSource = self
        picker1.delegate = self
        addSubview(picker1)
        picker2 = UIPickerView(frame: .zero)
        picker2.tag = 1
        picker2.dataSource = self
        picker2.delegate = self
        addSubview(picker2)
        
        picker1.selectRow(120, inComponent: 0, animated: false)
        picker2.selectRow(80, inComponent: 0, animated: false)
    }
}

extension _DoublePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(range[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        range.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectRow(row, tag: pickerView.tag)
    }
}

struct DoublePicker: UIViewRepresentable {
    
    @Binding var value1: Int
    @Binding var value2: Int
    
    class Coordinator: _DoublePickerViewDelegate {
        
        var parent: DoublePicker
        
        init(_ parent: DoublePicker) {
            self.parent = parent
        }
        
        func didSelectRow(_ row: Int, tag: Int) {
            if tag == 0 {
                parent.value1 = row
            } else {
                parent.value2 = row
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> _DoublePickerView {
        let view = _DoublePickerView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: _DoublePickerView, context: Context) {
        
    }
    
    typealias UIViewType = _DoublePickerView
    
}
