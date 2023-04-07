//
//  IndicatorGraph.swift
//  IndicatorGraph
//
//  Created by VladyslavMac on 10.10.2022.
//

import UIKit

struct GraphSample {
    var index: Int
    var interval: DateInterval
    var indicators: [RealmIndicator]
    
    func getAverage() -> Double {
        indicators.map { $0.value }.reduce(0, +) / Double(indicators.count == 0 ? 1 : indicators.count)
    }
}

private class _GraphCell: UICollectionViewCell {
    
    var indicatorType: __HealthIndicatorType = .oxygen

    var timeMode: IndicatorGraphMode = .day

    var maxY: CGFloat = 0.0
    var minY: CGFloat = 0.0

    var verticalValues: [Int] = []
    var horizontalValues: [String] = [] {
        didSet {
            if oldValue.count == horizontalValues.count {
                refresh()
            } else {
                setupLabels()
            }
        }
    }
    
    var samples: [[GraphSample]] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    private var labels: [UILabel] = []

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        for sample in samples {
            
            let points = convertToPoints(sample)
            
            guard points.count > 1 else { continue }
            
            ctx.setStrokeColor(getLineColor().cgColor)
            
            ctx.setLineWidth(1.2)
            let path = createCurveForGradient(
                from: points, withSmoothness: 0.6, onlyCurve: false).cgPath
            
            ctx.addPath(path)

            ctx.clip()
            
            let colors = [getLineColor().cgColor, UIColor(white: 1, alpha: 0).cgColor]
            let grad = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: nil)!
            ctx.drawLinearGradient(
                grad,
                start: .init(x: rect.midX, y: 0), end: .init(x: rect.midX, y: rect.maxY), options: [])
            ctx.resetClip()
            
            ctx.clip(to: [
                .init(x: 0, y: 0, width: bounds.width, height: maxY)
            ])
            
            ctx.addPath(createCurve(
                from: points, withSmoothness: 0.6, onlyCurve: true).cgPath)
            ctx.strokePath()
            
        }
    }

    func getY(y: CGFloat) -> CGFloat {
        
        let minYValue = CGFloat(verticalValues.min()!)
        let maxYValue = CGFloat(verticalValues.max()!)
        
        let k = 1 - (y - minYValue) / (maxYValue - minYValue)
        
        return (maxY - minY) * k + minY
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let labelW = bounds.width / CGFloat(horizontalValues.count)
        
        for i in 0..<labels.count {
            labels[i].frame.origin.x = CGFloat(i) * labelW
            labels[i].frame.origin.y = bounds.height - 40
            labels[i].frame.size = .init(width: labelW, height: 30)
        }
    }
}

// UI
private extension _GraphCell {
    func setupLabels() {

        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll()

        for i in 0..<horizontalValues.count {
            let label = UILabel()
            label.text = horizontalValues[i]
            label.font = .systemFont(ofSize: 16)
            label.textAlignment = .left
            labels.append(label)
            label.textColor = UIColor(white: 200.0 / 255.0, alpha: 1)
            addSubview(label)

            if self.timeMode == .year || timeMode == .week {
                label.textAlignment = .center
            }
        }
        
        if timeMode == .month {
            labels[0].textAlignment = .left
            labels[1].textAlignment = .right
        }
    }

    func refresh() {
        for i in 0..<horizontalValues.count {
            labels[i].text = "\(horizontalValues[i])"
        }
    }
}

// DRAWING
private extension _GraphCell {
    
    func convertToPoints(_ samples: [GraphSample]) -> [CGPoint] {
        var points = [CGPoint]()
        for sample in samples {
            var point = CGPoint.zero
            point.x = bounds.maxX * (CGFloat(sample.index) / 9.0)
            let avg = sample.getAverage()
            point.y = getY(y: avg) //  avg < minYValue ? getY(y: minYValue) : getY(y: avg)
            if avg > 0 {
                points.append(point)
            }
        }
        return points
    }
    func getLineColor() -> UIColor {
        switch indicatorType {
        case .pressure:
            return UIColor(red: 1, green: 0.66, blue: 0.64, alpha: 1)
        case .heartrate:
            return UIColor(red: 1, green: 0.66, blue: 0.64, alpha: 1)
        case .sugar:
            return UIColor(red: 0.48, green: 0.71, blue: 1, alpha: 1)
        case .insuline:
            return UIColor(red: 0.55, green: 0.68, blue: 1, alpha: 1)
        case .oxygen:
            return UIColor(red: 0.56, green: 0.68, blue: 0.98, alpha: 1)
        default:
            return UIColor(red: 1, green: 0.77, blue: 0.7, alpha: 1)
        }
    }
    func createCurveForGradient(
        from points: [CGPoint],
        withSmoothness smoothness: CGFloat,
        onlyCurve: Bool
    ) -> UIBezierPath {

        let path = UIBezierPath()
        guard points.count > 0 else { return path }
        var prevPoint: CGPoint = points.first!
        
        path.move(to: points[0])
        //path.addLine(to: points[0])
        
        for i in 1..<points.count {
            let cp = controlPoints(p1: prevPoint, p2: points[i], smoothness: smoothness)
            path.addCurve(to: points[i], controlPoint1: cp.0, controlPoint2: cp.1)
            prevPoint = points[i]
        }

        if !onlyCurve {
            path.addLine(to: .init(x: points.last?.x ?? bounds.width, y: maxY))
            path.addLine(to: .init(x: points[0].x, y: maxY))
            path.addLine(to: points[0])
            path.close()
        }
        return path
    }
    func createCurve(
        from points: [CGPoint],
        withSmoothness smoothness: CGFloat,
        addZeros: Bool = false,
        onlyCurve: Bool
    ) -> UIBezierPath {

        let path = UIBezierPath()
        guard points.count > 0 else { return path }
        var prevPoint: CGPoint = points.first!
        let interval = getXLineInterval()
        if addZeros {
            path.move(to: CGPoint(x: interval.origin.x, y: interval.origin.y))
            path.addLine(to: points[0])
        }
        else {
            path.move(to: points[0])
        }
        for i in 1..<points.count {
            let cp = controlPoints(p1: prevPoint, p2: points[i], smoothness: smoothness)
            path.addCurve(to: points[i], controlPoint1: cp.0, controlPoint2: cp.1)
            prevPoint = points[i]
        }
        if addZeros {
            path.addLine(to: CGPoint(x: prevPoint.x, y: interval.origin.y))
        }
        
        if !onlyCurve {
            path.addLine(to: .init(x: bounds.width, y: maxY))
            path.addLine(to: .init(x: 0, y: maxY))
            path.addLine(to: points[0])
        }
        return path
    }
    func controlPoints(p1: CGPoint, p2: CGPoint, smoothness: CGFloat) -> (CGPoint, CGPoint) {
        let cp1: CGPoint!
        let cp2: CGPoint!
        let percent = min(1, max(0, smoothness))
        do {
            var cp = p2
            let x0 = max(p1.x, p2.x)
            let x1 = min(p1.x, p2.x)
            let x = x0 + (x1 - x0) * percent
            cp.x = x
            cp2 = cp
        }
        do {
            var cp = p1
            let x0 = min(p1.x, p2.x)
            let x1 = max(p1.x, p2.x)
            let x = x0 + (x1 - x0) * percent
            cp.x = x
            cp1 = cp
        }
        return (cp1, cp2)
    }
    func getXLineInterval() -> CGRect {
        return CGRect.zero
    }
}

enum IndicatorGraphMode {
    case day, week, month, year
}

class IndicatorGraph: UIView {
    
    var indicatorType: __HealthIndicatorType = .oxygen {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var mode: IndicatorGraphMode = .day {
        didSet {
            switch mode {
            case .day:
                horizontalValues = ["00", "06", "12", "18"]
                collectionView.reloadData()
            case .week:
                horizontalValues = ["Mo", "We", "Fr", "Su"]
                collectionView.reloadData()
            case .month:
                let startEnd = Date.getMonthStartEnd()
                let formatter = DateFormatter()
                formatter.dateFormat = "LLL d"
                let s1 = formatter.string(from: startEnd.start)
                let s2 = formatter.string(from: startEnd.end)
                horizontalValues = [s1, s2]
                collectionView.reloadData()
            case .year:
                let date = Date()
                let components = Calendar.current.dateComponents([.year], from: date)
                horizontalValues = ["\(components.year ?? 2001)"]
                collectionView.reloadData()
            }
        }
    }
    
    var samples: [[GraphSample]] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var verticalValues: [Int] = []

    var horizontalValues: [String] = ["00", "06", "12", "18"]

    private var verticalLabels: [UILabel] = []

    private var collectionView: UICollectionView!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setStrokeColor(UIColor.lightGray.cgColor)
        ctx.setLineWidth(0.5)
        let labelH = (bounds.height - 20) / 5
        for i in 0..<verticalLabels.count {
            ctx.move(to: .init(x: 50, y: CGFloat(i) * labelH + labelH / 2))
            ctx.addLine(to: .init(x: bounds.width, y: CGFloat(i) * labelH + labelH / 2))
        }
        ctx.setLineDash(phase: 2.3, lengths: [2.3])
        ctx.strokePath()
    }

    convenience init(verticalValues: [Int], indicatorType: __HealthIndicatorType) {
        self.init(frame: .zero)
        self.verticalValues = verticalValues
        self.indicatorType = indicatorType
        setupVerticalLabels()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        let lay = UICollectionViewFlowLayout()
        lay.scrollDirection = .horizontal
        collectionView = UICollectionView(
            frame: bounds, collectionViewLayout: lay)
        collectionView.register(_GraphCell.self, forCellWithReuseIdentifier: "id")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let labelH = (bounds.height - 20) / 5
        for i in 0..<verticalLabels.count {
            verticalLabels[i].frame.origin.y = CGFloat(i) * labelH
            verticalLabels[i].frame.size = .init(width: 30, height: labelH)
        }
        collectionView.frame = .init(x: 50, y: 0, width: bounds.width - 50, height: bounds.height)
    }

    private func setupVerticalLabels() {
        for i in 0..<5 {
            let label = UILabel()
            label.text = "\(verticalValues[verticalValues.count - i - 1])"
            label.alpha = CGFloat(5 - i - 1) / 5 + 0.4
            label.font = .systemFont(ofSize: 16)
            label.textAlignment = .right
            verticalLabels.append(label)
            label.textColor = UIColor(white: 0.4, alpha: 1)
            addSubview(label)
        }
    }

    private func getGraphMinY() -> CGFloat {
        let labelH = (bounds.height - 20) / 5
        return labelH / 2
    }

    private func getGraphMaxY() -> CGFloat {
        let labelH = (bounds.height - 20) / 5
        return 4 * labelH + labelH / 2
    }
}

extension IndicatorGraph: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! _GraphCell
        cell.timeMode = mode
        cell.indicatorType = indicatorType
        cell.maxY = getGraphMaxY()
        cell.minY = getGraphMinY()
        cell.verticalValues = verticalValues
        cell.horizontalValues = horizontalValues
        cell.backgroundColor = .clear
        cell.samples = samples
        return cell
    }

}
extension IndicatorGraph: UICollectionViewDelegateFlowLayout {
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

