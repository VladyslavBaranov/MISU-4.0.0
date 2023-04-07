//
//  IndicatorsLineChart.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 11.12.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI
import Charts

struct IndicatorsLineChart: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: ChartViewDelegate {
        
        var parent: IndicatorsLineChart
        
        init(_ parent: IndicatorsLineChart) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            parent.onValueSelected?(entry)
        }
    }
    
    @State var type: __HealthIndicatorType
    var onValueSelected: ((ChartDataEntry) -> ())?
    
    func makeUIView(context: Context) -> IndicatorsLineChartView {
        let view = IndicatorsLineChartView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: IndicatorsLineChartView, context: Context) {
        uiView.setIndicatorType(type)
    }

    typealias UIViewType = IndicatorsLineChartView
    
}
