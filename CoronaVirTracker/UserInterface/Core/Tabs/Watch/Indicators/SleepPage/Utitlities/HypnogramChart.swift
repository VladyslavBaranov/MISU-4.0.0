//
//  HypnogramChart.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 16.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import Foundation
import Charts
import SwiftUI

class _HypnogramChart: LineChartView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        highlightPerTapEnabled = false
        highlightPerDragEnabled = false
        xAxis.drawGridLinesEnabled = false
        leftAxis.drawGridLinesEnabled = false
        chartDescription.enabled = false
        xAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        legend.enabled = false
        doubleTapToZoomEnabled = false
        minOffset = 0.0
        pinchZoomEnabled = false
        
        
        
        leftAxis.granularity = 1.0
        leftAxis.valueFormatter = StagesAxisValueFormatter()
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = true
        leftAxis.labelTextColor = UIColor.gray
        leftAxis.axisLineColor = UIColor.gray
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        xAxis.drawLabelsEnabled = true
        xAxis.valueFormatter = HoursAxisValueFormatter.init(startHour: "00:00")
        xAxis.labelTextColor = UIColor.gray
        xAxis.axisLineColor = UIColor.gray
        xAxis.labelFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        
        setVisibleXRangeMaximum(3)
        
        backgroundColor = UIColor.white
    }
    
    func setHypno(_ input: [Int], startHour: String) {
        let hypno = Hypnogram(basicHypno: input)
        xAxis.valueFormatter = HoursAxisValueFormatter.init(startHour: "\(startHour):00")
        let data = LineChartData.init(dataSets: hypno.getDataSets(hypno: hypno.getHypnoWithPoints()))
        self.data = data
        setVisibleXRangeMaximum(60)
    }
}

struct HypnogramChart: UIViewRepresentable {
    
    @Binding var phases: RealmSleepIndicator
    
    func makeUIView(context: Context) -> _HypnogramChart {
        let chart = _HypnogramChart(frame: .zero)
        let phases = phases.getPhases()
        
        let firstPhaseHour = phases.first?.start.hour ?? 0
        let hour = firstPhaseHour < 10 ? "0\(firstPhaseHour)" : "\(firstPhaseHour)"
        
        chart.setHypno(phases.map { $0.type }, startHour: hour)
        return chart
    }
    
    func updateUIView(_ uiView: _HypnogramChart, context: Context) {
        let phases = phases.getPhases()
        
        let firstPhaseHour = phases.first?.start.hour ?? 0
        let hour = firstPhaseHour < 10 ? "0\(firstPhaseHour)" : "\(firstPhaseHour)"
        
        uiView.setHypno(phases.map { $0.type }, startHour: hour)
    }
    
    typealias UIViewType = _HypnogramChart
    
}
