//
//  CalendarViewModel.swift
//  Babysitter
//
//  Created by Jovito Royeca on 14.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import Foundation

enum PayRate : Double {
    case startToBedtimeRate    = 12.0
    case bedtimeToMidnightRate = 8.0
    case midnightToEndRate     = 16.0
    
    var description : String {
        switch self {
        case .startToBedtimeRate: return "Start to Bedtime"
        case .bedtimeToMidnightRate: return "Bedtime to Midnight"
        case .midnightToEndRate: return "Midnight to End"
        }
    }
}

class CalendarViewModel: NSObject {
    // MARK: Variables
    var selectedDate = Date()
    var currentDate = Date()
    
    // MARK: UITableView methods
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return [1,24][section]
    }
    
    // MARK: Database methods
    func dateString() -> String {
        let formatter = DateFormatter()
        let calendar = NSCalendar(identifier: .gregorian)!
        var components = DateComponents()
        
        components.year = calendar.component(.year, from: selectedDate)
        components.month = calendar.component(.month, from: selectedDate)
        components.day = calendar.component(.day, from: selectedDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let startDate = calendar.date(from: components)
        
        components.day = calendar.component(.day, from: selectedDate) + 1
        let endDate = calendar.date(from: components)
        
        formatter.dateFormat = "MMM dd"
        
        return "\(formatter.string(from: startDate!)) - \(formatter.string(from: endDate!))"
    }
    
    func getWorkOnSelectedDate() -> WorkModel? {
        let calendar = NSCalendar(identifier: .gregorian)!
        var components = DateComponents()
        var startDate: Date?
        var endDate: Date?
        
        components.year = calendar.component(.year, from: selectedDate)
        components.month = calendar.component(.month, from: selectedDate)
        components.day = calendar.component(.day, from: selectedDate)
        components.hour = 17
        components.minute = 0
        components.second = 0
        startDate = calendar.date(from: components)
        
        components.day = calendar.component(.day, from: selectedDate) + 1
        components.hour = 4
        endDate = calendar.date(from: components)
        
        guard let result = CoreDataAPI.sharedInstance.findWorks(startDate: startDate! as NSDate,
                                                                endDate: endDate! as NSDate) else {
            return nil
        }
        
        return result.first
    }
    
    func getPreviousWorkOnSelectedDate() -> WorkModel? {
        let calendar = NSCalendar(identifier: .gregorian)!
        var components = DateComponents()
        var startDate: Date?
        var endDate: Date?
        
        components.year = calendar.component(.year, from: selectedDate)
        components.month = calendar.component(.month, from: selectedDate)
        components.day = calendar.component(.day, from: selectedDate) - 1
        components.hour = 17
        components.minute = 0
        components.second = 0
        startDate = calendar.date(from: components)
        
        components.day = calendar.component(.day, from: selectedDate)
        components.hour = 4
        endDate = calendar.date(from: components)
        
        guard let result = CoreDataAPI.sharedInstance.findWorks(startDate: startDate! as NSDate,
                                                                endDate: endDate! as NSDate) else {
                                                                    return nil
        }
        
        return result.first
    }
    
    func saveWork() {
        let calendar = NSCalendar(identifier: .gregorian)!
        var components = DateComponents()
        var hours = 0
        var startDate: Date?
        var bedtimeDate: Date?
        var midnightDate: Date?
        var endDate: Date?
        var startToBedtimePay = 0.0
        var bedtimeToMidnightPay = 0.0
        var midnightToEndPay = 0.0
        
        components.year = calendar.component(.year, from: selectedDate)
        components.month = calendar.component(.month, from: selectedDate)
        components.day = calendar.component(.day, from: selectedDate)
        components.hour = 17
        components.minute = 0
        components.second = 0
        startDate = calendar.date(from: components)
        
        hours = 4
        components.hour! += hours
        bedtimeDate = calendar.date(from: components)
        startToBedtimePay = Double(hours) * PayRate.startToBedtimeRate.rawValue
        
        hours = 3
        components.day = calendar.component(.day, from: selectedDate) + 1
        components.hour = 0
        midnightDate = calendar.date(from: components)
        bedtimeToMidnightPay = Double(hours) * PayRate.bedtimeToMidnightRate.rawValue
        
        hours = 4
        components.hour! = hours
        endDate = calendar.date(from: components)
        midnightToEndPay = Double(hours) * PayRate.midnightToEndRate.rawValue
        
        let totalHours = Int32(11)
        let totalPay = startToBedtimePay +
            bedtimeToMidnightPay +
            midnightToEndPay
        
        CoreDataAPI.sharedInstance.saveWork(startDate: startDate! as NSDate,
                                            bedtimeDate: bedtimeDate! as NSDate,
                                            midnightDate: midnightDate! as NSDate,
                                            endDate: endDate! as NSDate,
                                            startToBedtimePay: startToBedtimePay,
                                            bedtimeToMidnightPay: bedtimeToMidnightPay,
                                            midnightToEndPay: midnightToEndPay,
                                            totalHours: totalHours,
                                            totalPay: totalPay)
    }
    
    func deleteWork() {
        let calendar = NSCalendar(identifier: .gregorian)!
        var components = DateComponents()
        var startDate: Date?
        var endDate: Date?
        
        components.year = calendar.component(.year, from: selectedDate)
        components.month = calendar.component(.month, from: selectedDate)
        components.day = calendar.component(.day, from: selectedDate)
        components.hour = 17
        components.minute = 0
        components.second = 0
        startDate = calendar.date(from: components)
        
        components.day = calendar.component(.day, from: selectedDate) + 1
        components.hour = 4
        endDate = calendar.date(from: components)
        
        CoreDataAPI.sharedInstance.deleteWork(startDate: startDate! as NSDate,
                                              endDate: endDate! as NSDate)
    }
}
