//
//  Date_Extension.swift
//  IndicatorGraph
//
//  Created by VladyslavMac on 09.10.2022.
//

import Foundation

extension Calendar {
    
    func currentWeekBoundary() -> DateInterval? {
        return weekBoundary(for: Date())
    }
    
    func weekBoundary(for date: Date) -> DateInterval? {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        
        guard let startOfWeek = self.date(from: components) else {
            return nil
        }
        
        let endOfWeekOffset = weekdaySymbols.count - 1
        let endOfWeekComponents = DateComponents(day: endOfWeekOffset, hour: 23, minute: 59, second: 59)
        guard let endOfWeek = self.date(byAdding: endOfWeekComponents, to: startOfWeek) else {
            return nil
        }
        
        return .init(start: startOfWeek, end: endOfWeek)
    }
}

struct DateInterval {
    var start: Date
    var end: Date
    
    func contains(_ date: Date) -> Bool {
        return date >= start && date <= end
    }
    
    func breakPeriod(interval: Int) -> [DateInterval] {
        let distance = start.distance(to: end) / Double(interval)
        var date = start
        var result: [DateInterval] = []
        for _ in 1...interval {
            date.addTimeInterval(distance)
            result.append(.init(start: date.addingTimeInterval(-distance), end: date))
        }
        return result
    }
}



extension Date {
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    func monthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        return formatter.string(from: self)
    }
    
    func getDayStartEnd() -> DateInterval {
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        
        let day = components.day!
        let month = components.month!
        let year = components.year!
        
        var start = DateComponents()
        start.day = day
        start.month = month
        start.year = year
        start.hour = 0
        start.minute = 0
        
        var end = DateComponents()
        end.day = day
        end.month = month
        end.year = year
        end.hour = 24
        end.minute = 0
        
        let sDate = Calendar.current.date(from: start)
        let eDate = Calendar.current.date(from: end)
        
        return .init(start: sDate!, end: eDate!)
    }
    
    func getStartEndOfWeek() -> DateInterval? {
        var calendar = Calendar(identifier: .iso8601)
        calendar.firstWeekday = 2
        return calendar.weekBoundary(for: self)
    }
    
    func getMonthStartEnd() -> DateInterval {
        return .init(start: startOfMonth(), end: endOfMonth())
    }
    
    
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    
    
    static func getMonthStartEnd() -> DateInterval {
        let date = Date()
        return .init(start: date.startOfMonth(), end: date.endOfMonth())
    }
    
    static func toDate(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter.date(from: str)!
    }
    
    static func generateHoursFromCurrent() -> [Date] {
        var dates: [Date] = []
        let curDate = Date()
        var date = Calendar.current.date(bySettingHour: curDate.hour, minute: 0, second: 0, of: curDate)!
        for _ in 0..<(9 * 10) {
            dates.append(date)
            date.addTimeInterval(-3600)
        }
        return dates
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func toTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
