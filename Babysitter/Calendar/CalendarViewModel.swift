//
//  CalendarViewModel.swift
//  Babysitter
//
//  Created by Jovito Royeca on 14.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import Foundation

/*
 * Business contants for pay rates
 */
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

/*
 * The View-Model class in MVVC. Handles data transformation and business logic operations.
 */
class CalendarViewModel: NSObject {
    // MARK: Variables
    
    /*
     * The selected date in calendar UI
     */
    var selectedDate = Date()
    
    /*
     * The current date
     */
    var currentDate = Date()
    
    // MARK: UITableView methods
    func numberOfSections() -> Int {
        return 2
    }
    
    /*
     * Supplies the section for the table view UI. The first section contains the ActionTableViewCell,
     * the second section contains 24 TimeTableViewCells to represent 24 hours.
     */
    func numberOfRows(inSection section: Int) -> Int {
        return [1,24][section]
    }
    
    // MARK: Display methods
    /*
     * Returns date from selected date to the next day, for example: Sep 18 - Sep 19
     */
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
    
    /*
     * Returms AM/PM format for hours
     */
    func hourString(hour: Int) -> String {
        return "\(hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)) \(hour >= 12 ? "PM" : "AM")"
    }

    /*
     * Returns if the hour parameter is in the work shift.
     */
    func hourEnabled(hour: Int) -> Bool {
        let work = getWorkOnSelectedDate()
        let previousWork = getPreviousWorkOnSelectedDate()
        var enabled = false
        
        guard let newDate = getCleanDate(from: selectedDate) else {
            return enabled
        }
        
        if hour > 0 && hour <= 4 {
            if previousWork != nil && previousWork?.endDate != nil {
                if newDate.compare(getCleanDate(from: previousWork!.endDate! as Date)!) == .orderedSame {
                    enabled = true
                }
            }
        } else if hour >= 17 && hour < 21 {
            if work != nil && work?.startDate != nil {
                if newDate.compare(getCleanDate(from: work!.startDate! as Date)!) == .orderedSame {
                    enabled = true
                }
            }
        } else if hour >= 21 && hour <= 24 {
            if work != nil && work?.startDate != nil {
                if newDate.compare(getCleanDate(from: work!.startDate! as Date)!) == .orderedSame {
                    enabled = true
                }
            }
        }
        
        return enabled
    }
    
    /*
     * Returns the hour description in the work shift.
     */
    func hourDescription(hour: Int) -> String {
        let work = getWorkOnSelectedDate()
        let previousWork = getPreviousWorkOnSelectedDate()
        var descriptionString = " "
        
        guard let newDate = getCleanDate(from: selectedDate) else {
            return descriptionString
        }
        
        if hour > 0 && hour <= 4 {
            if previousWork != nil && previousWork?.endDate != nil {
                if newDate.compare(getCleanDate(from: previousWork!.endDate! as Date)!) == .orderedSame {
                    descriptionString = PayRate.midnightToEndRate.description
                }
            }
        } else if hour >= 17 && hour < 21 {
            if work != nil && work?.startDate != nil {
                if newDate.compare(getCleanDate(from: work!.startDate! as Date)!) == .orderedSame {
                    descriptionString = PayRate.startToBedtimeRate.description
                }
            }
        } else if hour >= 21 && hour <= 24 {
            if work != nil && work?.startDate != nil {
                if newDate.compare(getCleanDate(from: work!.startDate! as Date)!) == .orderedSame {
                    descriptionString = PayRate.bedtimeToMidnightRate.description
                }
            }
        }
        
        return descriptionString
    }
    
    /*
     * Returns the rate of pay for the hour parameter in the work shift.
     */
    func hourPrice(hour: Int) -> String {
        let work = getWorkOnSelectedDate()
        let previousWork = getPreviousWorkOnSelectedDate()
        var priceString = " "
        
        guard let newDate = getCleanDate(from: selectedDate) else {
            return description
        }
        
        if hour > 0 && hour <= 4 {
            if previousWork != nil && previousWork?.endDate != nil {
                if newDate.compare(getCleanDate(from: previousWork!.endDate! as Date)!) == .orderedSame {
                    priceString = String(format: "$%.2f", PayRate.midnightToEndRate.rawValue)
                }
            }
        } else if hour >= 17 && hour < 21 {
            if work != nil && work?.startDate != nil {
                if newDate.compare(getCleanDate(from: work!.startDate! as Date)!) == .orderedSame {
                    priceString = String(format: "$%.2f", PayRate.startToBedtimeRate.rawValue)
                }
            }
        } else if hour >= 21 && hour <= 23 {
            if work != nil && work?.startDate != nil {
                if newDate.compare(getCleanDate(from: work!.startDate! as Date)!) == .orderedSame {
                    priceString = String(format: "$%.2f", PayRate.bedtimeToMidnightRate.rawValue)
                }
            }
        }
        
        return priceString
    }
    
    // MARK: Utility methods
    /*
     * Returns a date set at midnight from the supplied date parameter.
     */
    func getCleanDate(from date: Date) -> Date? {
        let calendar = NSCalendar(identifier: .gregorian)!
        var components = DateComponents()
        
        components.year = calendar.component(.year, from: date)
        components.month = calendar.component(.month, from: date)
        components.day = calendar.component(.day, from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)
    }
    
    // MARK: Database methods
    /*
     * Queries the Core Data for a Babysitting work from the selectedDate.
     */
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
        
        let result = CoreDataAPI.sharedInstance.findWorks(startDate: startDate! as NSDate,
                                                          endDate: endDate! as NSDate)
        return result.first
    }
    
    /*
     * Queries the Core Data for a Babysitting work one-day before the selectedDate.
     */
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
        
        let result = CoreDataAPI.sharedInstance.findWorks(startDate: startDate! as NSDate,
                                                          endDate: endDate! as NSDate)
        return result.first
    }
    
    /*
     * Queries the Core Data for a Babysitting works from the supplied date range.
     */
    func findWorks(startDate: Date,
                   endDate: Date) -> [WorkModel]? {
        return CoreDataAPI.sharedInstance.findWorks(startDate: startDate as NSDate,
                                                    endDate: endDate as NSDate)
    }

    /*
     * Saves the Babysitting work to Core Data.
     * Calculates the totalPay and totalHous.
     */
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
        
        // 5PM to 9PM    = 4 * 12 = 48
        // 9PM to 12 AM  = 3 * 8  = 24
        // 12AM to 4AM   = 4 * 16 = 64
        // total = 48 + 24 + 64   = 136
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
    
    /*
     * Deletes the Babysitting work in Core Data from the selectedDate.
     */
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
