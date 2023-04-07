//
//  SleepGraphView.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 19.10.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

extension Date {
    static func getDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        formatter.timeZone = .current
        return formatter.date(from: string) ?? Date()
    }
    static func generate9Hours() -> [Date] {
        var dates: [Date] = []
        let curDate = Date.getDate(from: "12.01.2023 23:00:00")
        var date = Calendar.current.date(bySettingHour: curDate.hour, minute: 0, second: 0, of: curDate)!
        for _ in 0..<9 {
            dates.append(date)
            date.addTimeInterval(3600)
        }
        return dates
    }
}

struct SleepGraphView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> _SleepGraphView {
        let view = _SleepGraphView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: _SleepGraphView, context: Context) {
        
    }
    
    typealias UIViewType = _SleepGraphView
    
}

struct Phase {
    var date = Date.getDate(from: "12.01.2023 23:00:00")
    var duration: TimeInterval
    var type: Int
}

final class _SleepGraphCanvas: UIView {
    
    var dates: [Date] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    static let verticalLineWidth: CGFloat = 2.0
    static let valuePadHeight: CGFloat = 8.0
    
    var phases: [_RealmSleepIndicatorPhase] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !phases.isEmpty else { return }
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        ctx.setFillColor(UIColor.blue.cgColor)
        
        let h = (rect.height - Self.valuePadHeight) / 3
        let w = rect.width / 9
        
        var previousY = -1
        var originX: CGFloat = (CGFloat(phases[0].start.minute) * w) / 60
        
        for (i, phase) in phases.enumerated() {
            
            let targetW = (phase.duration * w) / 3600
            ctx.move(to: .init(x: originX, y: rect.height - h * CGFloat(i) - Self.valuePadHeight))
            
            let y: CGFloat = rect.height - h * CGFloat(phase.type) - Self.valuePadHeight
            
            let rect = CGRect(
                x: originX - Self.verticalLineWidth / 2,
                y: y,
                width: CGFloat(targetW) + Self.verticalLineWidth,
                height: Self.valuePadHeight
            )
            let rounded = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: getCornersForType(phase.type),
                cornerRadii: .init(width: 2.5, height: 2.5))
            ctx.addPath(rounded.cgPath)
            ctx.setFillColor(getColorForType(phase.type).cgColor)
            ctx.fillPath()
            
            if i != 0 {
                
                let estheight = abs(CGFloat(previousY - phase.type))
                let estY = y + Self.valuePadHeight
                let columnRect = CGRect(
                    x: originX - Self.verticalLineWidth / 2,
                    y: phase.type < previousY ? estY - h * estheight : estY,
                    width: Self.verticalLineWidth,
                    height: h * estheight - Self.valuePadHeight
                )
                ctx.addRect(columnRect)
                ctx.setFillColor(phase.type < previousY ? getVLineColorForType(previousY).cgColor : getVLineColorForType(phase.type).cgColor)
                ctx.fillPath()
                
            }
            
            originX += CGFloat(targetW)
            previousY = phase.type
            
        }
        
        
    }
    
    /*
    private func placeDash(for phase: Phase, in ctx: CGContext, width: CGFloat) {
        
        let h = (bounds.height - Self.valuePadHeight) / 3
        
        let minDate = Double(dates[0].hour)
        let maxDate = Double(dates[8].hour)
        let hour = Double(phase.date.addingTimeInterval(phase.duration).hour)
        
        let minute = Double(phase.date.addingTimeInterval(phase.duration).minute)
        let minuteShift = CGFloat((minute * width / 9) / 600)
        
        let k = Double.getPercent(min: minDate, max: maxDate, target: hour)
        
        
        guard k.isBetween(0, 1) else { return }
        
        
        
        let actualW = width - width / 9
        let x = actualW * (1 - k)
        
        // print(1 - k, hour, x)
        
        ctx.setFillColor(getColorForType(phase.type).cgColor)
        
        let y: CGFloat = bounds.height - h * CGFloat(phase.type) - Self.valuePadHeight
        
        let dashWidth: CGFloat = (phase.duration * width / 9) / 3600
        let rect = CGRect(
            x: CGFloat(x) - Self.verticalLineWidth / 2 + minuteShift,
            y: y,
            width: dashWidth + Self.verticalLineWidth,
            height: Self.valuePadHeight
        )
        let roundedRect = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: getCornersForType(phase.type),
            cornerRadii: .init(width: 2.5, height: 2.5))
        
        ctx.addPath(roundedRect.cgPath)
        ctx.fillPath()
        
    }
    */
    
    private func getColorForType(_ int: Int) -> UIColor {
        switch int {
        case 0:
            return UIColor(red: 37.0 / 255, green: 80.0 / 255, blue: 203.0 / 255, alpha: 1)
        case 1:
            return UIColor(red: 118.0 / 255, green: 154.0 / 255, blue: 248.0 / 255, alpha: 1)
        case 2:
            return UIColor(red: 148.0 / 255, green: 153.0 / 255, blue: 247.0 / 255, alpha: 1)
        default:
            return UIColor(red: 202.0 / 255, green: 161.0 / 255, blue: 249.0 / 255, alpha: 1)
        }
    }
    
    private func getVLineColorForType(_ int: Int) -> UIColor {
        getColorForType(int).withAlphaComponent(0.35)
    }
    
    private func getCornersForType(_ int: Int) -> UIRectCorner {
        switch int {
        case 0:
            return [.bottomRight, .bottomLeft]
        case 1, 2, 3:
            return [.topLeft, .topRight]
        default:
            return [.topLeft, .topRight]
        }
    }
    
}

final class _SleepGraphViewCollectionViewCell: UICollectionViewCell {
    
    var sleepRecordings: [_RealmSleepIndicatorPhase] = [] {
        didSet {
            canvas?.phases = sleepRecordings
        }
    }
    
    var phases: [_RealmSleepIndicatorPhase] = []
    
    var dates: [Date] = [] {
        didSet {
            for i in 0..<dates.count {
                let hour = dates[i].hour
                let str = hour > 9 ? "\(hour)" : "0\(hour)"
                // labels[labels.count - i - 1].text = str
                canvas.dates = dates
            }
        }
    }
    
    private var canvas: _SleepGraphCanvas!
    
    private var labels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
        canvas = _SleepGraphCanvas(frame: .init(x: 0, y: 0, width: frame.width, height: frame.height - 38))
        addSubview(canvas)
        canvas.backgroundColor = .clear
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let labelW = bounds.width / 9.0
        
        for i in 0..<9 {
            labels[i].frame.origin.x = CGFloat(i) * labelW
            labels[i].frame.origin.y = bounds.height - 38
            labels[i].frame.size = .init(width: labelW, height: 38)
        }
        canvas.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height - 38)
    }
    
    func setupLabels() {
        /// guard !phases.isEmpty else { return }
        var date = Date()
        for _ in 0..<9 {
            let label = UILabel()
            let hour = date.hour
            let str = hour > 9 ? "\(hour)" : "0\(hour)"
            label.text = str
            label.font = .systemFont(ofSize: 16)
            label.textAlignment = .center
            label.textColor = UIColor(white: 0.75, alpha: 1)
            addSubview(label)
            labels.append(label)
            date.addTimeInterval(3600)
        }
    }
}

final class _SleepGraphView: UIView {
    
    private var sleepRecordings = RealmSleepIndicator.getAll()
    
    private var dates = Date.generateHoursFromCurrent().chunked(into: 9)
    
    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        let lay = UICollectionViewFlowLayout()
        lay.scrollDirection = .horizontal
        collectionView = UICollectionView(
            frame: bounds, collectionViewLayout: lay)
        collectionView.register(_SleepGraphViewCollectionViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.collectionView.scrollToItem(at: .init(row: 9, section: 0), at: .centeredHorizontally, animated: false)
            self?.collectionView.visibleCells.forEach({ cell in
                cell.setNeedsDisplay()
            })
        }
         */
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setStrokeColor(UIColor.lightGray.cgColor)
        ctx.setLineWidth(0.5)
        let labelH = (bounds.height - 46) / 3
        for i in 0..<4 {
            ctx.move(to: .init(x: 0, y: CGFloat(i) * labelH + 8))
            ctx.addLine(to: .init(x: bounds.width, y: CGFloat(i) * labelH + 8))
        }
        ctx.setLineDash(phase: 2.3, lengths: [2.3])
        ctx.strokePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
}

extension _SleepGraphView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! _SleepGraphViewCollectionViewCell
        cell.dates = Date.generate9Hours()
        cell.sleepRecordings = sleepRecordings.last!.getPhases()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

