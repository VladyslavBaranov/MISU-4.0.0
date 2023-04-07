//
//  MultilineTextField.swift
//  NotifyTest
//
//  Created by Vladyslav Baranov on 02.07.2022.
//

import SwiftUI

struct MultilineTextField: UIViewRepresentable {
    
    @Binding var text: String
    
    var onLineCountChange: ((Int, CGFloat) -> ())
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultilineTextField
        
        init(_ parent: MultilineTextField) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let numLines = Int(textView.contentSize.height / textView.font!.lineHeight)
            parent.text = textView.text
            parent.onLineCountChange(numLines, UIFont.systemFont(ofSize: 18).lineHeight)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = "Написати повідомлення..."
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = CustomFonts.createUIInter(weight: .regular, size: 18)
        textView.delegate = context.coordinator
        textView.frame.size.height = textView.font!.lineHeight + 20
        textView.tintColor = .blue
        textView.textColor = .black
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isEmpty {
            uiView.text = ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    typealias UIViewType = UITextView
    
}
