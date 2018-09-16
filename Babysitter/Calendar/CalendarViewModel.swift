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
        let work = getWorkOnSelectedDate()
        
        return [1, work != nil ? 24 : 0][section]
    }
    
    // MARK: Database methods
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
        
        guard let result = CoreDataAPI.sharedInstance.findWork(startDate: startDate! as NSDate,
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
        
        hours = 2
        components.hour! += hours
        bedtimeDate = calendar.date(from: components)
        startToBedtimePay = Double(hours) * PayRate.startToBedtimeRate.rawValue
        
        hours = 5
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
