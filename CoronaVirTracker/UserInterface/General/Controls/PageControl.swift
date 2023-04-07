//
//  PageControl.swift
//  OnlineDoctorPage
//
//  Created by Vladyslav Baranov on 14.06.2022.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    
    let pageCount: Int
    @Binding var page: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.365, green: 0.608, blue: 0.973, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.894, green: 0.937, blue: 1, alpha: 1)
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = page
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = page
    }
    
    typealias UIViewType = UIPageControl
}
