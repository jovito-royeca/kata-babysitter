//
//  WorkModel+CoreDataProperties.swift
//  Babysitter
//
//  Created by Jovito Royeca on 15.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkModel> {
        return NSFetchRequest<WorkModel>(entityName: "WorkModel")
    }

    @NSManaged public var bedtimeDate: NSDate?
    @NSManaged public var midnightDate: NSDate?
    @NSManaged public var totalHours: Int32
    @NSManaged public var totalPay: Double
    @NSManaged public var startToBedtimePay: Double
    @NSManaged public var bedtimeToMidnightPay: Double
    @NSManaged public var midnightToEndPay: Double
    @NSManaged public var startDate: NSDate?
    @NSManaged public var endDate: NSDate?

}
