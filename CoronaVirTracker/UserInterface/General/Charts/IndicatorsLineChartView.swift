//
//  IndicatorsLineChartView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 11.12.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import UIKit
import Charts

class DateValueFormatter: NSObject, AxisValueFormatter {
    
    var dateFormatter: DateFormatter!
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

class IndicatorsLineChartView: LineChartView {
    
    var indicatorType: __HealthIndicatorType = .pressure
    
    var progressContainerView: UIView!
    var progressView: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let dateFormatterForXAxis = DateValueFormatter()
        xAxis.valueFormatter = dateFormatterForXAxis
        
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridColor = .init(white: 0.85, alpha: 1)
        leftAxis.gridLineDashPhase = 3
        leftAxis.gridLineDashLengths = [3]
        // leftAxis.labelFont = .systemFont(ofSize: 14, weight: .medium)
        
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        leftAxis.drawAxisLineEnabled = false
        xAxis.labelPosition = .bottom
        // xAxis.labelFont = .systemFont(ofSize: 14, weight: .medium)
        
        rightAxis.drawGridLinesEnabled = true
        rightAxis.enabled = false
        legend.enabled = false
    
        progressContainerView = UIView(frame: bounds)
        progressContainerView.backgroundColor = .white
        addSubview(progressContainerView)
        
        progressView = UIActivityIndicatorView(style: .medium)
        progressContainerView.addSubview(progressView)
        progressView.hidesWhenStopped = true
        progressView.startAnimating()
        
        setupGraphPeriodObservation()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadGraph),
            name: NotificationManager.shared.notificationName(for: .didUpdateIndicator),
            object: nil
        )
        
        IndicatorManager.shared.getBulkV2(for: indicatorType, period: .day) { indicators in
            DispatchQueue.main.async { [weak self] in
                self?.onEndedLoading()
                self?.setGraphData(indicators)
            }
        }
    }
    
    @objc func reloadGraph() {
        setIndicatorType(indicatorType)
    }
    
    @objc func onPeriodSelected(_ notification: Notification) {
        if let periondIntValue = notification.object as? Int {
            changePeriod()
            
            let period: HealthParamsEnum.StaticticRange
            
            switch periondIntValue {
            case 0:
                period = .day
            case 1:
                period = .week
            case 2:
                period = .month
            case 3:
                period = .year
            default:
                period = .year
            }
            
            IndicatorManager.shared.getBulkV2(for: indicatorType, period: period) { indicators in
                DispatchQueue.main.async { [weak self] in
                    self?.onEndedLoading()
                    self?.setGraphData(indicators)
                }
            }
        }
    }
    
    private func setupGraphPeriodObservation() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPeriodSelected(_:)),
            name: NotificationManager.shared.notificationName(for: .didSelectNewPeriodForGraph), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressContainerView.frame = bounds
        progressView.center = .init(x: bounds.midX, y: bounds.midY)
    }
    
    func setIndicatorType(_ type: __HealthIndicatorType) {
        indicatorType = type
    }
    
    private func configureDataSetStyling(_ dataSet: LineChartDataSet) {
        
        var gradientColors: [CGColor] = []
        switch indicatorType {
        case .pressure:
            gradientColors = [UIColor(red: 1, green: 0.66, blue: 0.64, alpha: 1).cgColor, UIColor.clear.cgColor]
            dataSet.colors = [UIColor(red: 1, green: 0.66, blue: 0.64, alpha: 1)]
            dataSet.setColor(UIColor(red: 1, green: 0.66, blue: 0.64, alpha: 1))
        case .heartrate:
            gradientColors = [UIColor(red: 1, green: 0.66, blue: 0.64, alpha: 1).cgColor, UIColor.clear.cgColor]
            dataSet.colors = [UIColor(red: 1, green: 0.66, blue: 0.64, alpha: 1)]
            dataSet.setColor(UIColor(red: 1, green: 0.66, blue: 0.64, alpha: 1))
        case .sugar:
            gradientColors = [UIColor(red: 0.48, green: 0.71, blue: 1, alpha: 1).cgColor, UIColor.clear.cgColor]
            dataSet.colors = [UIColor(red: 0.48, green: 0.71, blue: 1, alpha: 1)]
            dataSet.setColor(UIColor(red: 0.48, green: 0.71, blue: 1, alpha: 1))
        case .insuline:
            gradientColors = [UIColor(red: 0.55, green: 0.68, blue: 1, alpha: 1).cgColor, UIColor.clear.cgColor]
            dataSet.colors = [UIColor(red: 0.55, green: 0.68, blue: 1, alpha: 1)]
            dataSet.setColor(UIColor(red: 0.55, green: 0.68, blue: 1, alpha: 1))
        case .oxygen:
            gradientColors = [UIColor(red: 0.56, green: 0.68, blue: 0.98, alpha: 1).cgColor, UIColor.clear.cgColor]
            dataSet.colors = [UIColor(red: 0.56, green: 0.68, blue: 0.98, alpha: 1)]
            dataSet.setColor(UIColor(red: 0.56, green: 0.68, blue: 0.98, alpha: 1))
        case .temperature:
            gradientColors = [UIColor(red: 1, green: 0.774, blue: 0.696, alpha: 1).cgColor, UIColor.clear.cgColor]
            dataSet.colors = [UIColor(red: 1, green: 0.774, blue: 0.696, alpha: 1)]
            dataSet.setColor(UIColor(red: 1, green: 0.774, blue: 0.696, alpha: 1))
        default:
            break
        }
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: colorLocations)
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        dataSet.drawFilledEnabled = true
    }
    
    func setGraphData(_ input: [_HealthIndicator]) {
        var entries: [ChartDataEntry] = []
        for indicator in input {
            entries.append(.init(x: indicator.date.timeIntervalSinceReferenceDate, y: indicator.value))
        }
        
        let dataSet = LineChartDataSet(entries: entries)
        
        configureDataSetStyling(dataSet)
        
        let data = LineChartData(dataSets: [dataSet])
        
        if indicatorType == .pressure {
            var aEntries: [ChartDataEntry] = []
            for indicator in input {
                if let aValue = indicator.additionalValue {
                    aEntries.append(.init(x: indicator.date.timeIntervalSinceReferenceDate, y: aValue))
                }
            }
            let aDataSet = LineChartDataSet(entries: aEntries)
            aDataSet.mode = .horizontalBezier
            aDataSet.label = ""
            aDataSet.drawCirclesEnabled = false
            aDataSet.drawIconsEnabled = false
            aDataSet.drawValuesEnabled = false
            aDataSet.lineWidth = 1
            
            configureDataSetStyling(aDataSet)
            data.dataSets.append(aDataSet)
        }
        
        dataSet.mode = .cubicBezier
        dataSet.label = ""
        dataSet.drawCirclesEnabled = false
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = 1
    
        self.data = data
    }
    
    func changePeriod() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.progressContainerView.alpha = 1
        } completion: { [weak self] _ in
            self?.progressContainerView.isHidden = false
        }
    }
    
    private func onEndedLoading() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.progressContainerView.alpha = 0
        } completion: { [weak self] _ in
            self?.progressContainerView.isHidden = true
        }
    }
}


