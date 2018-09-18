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

    /*
     * Bedtime usually set to 10PM.
     */
    @NSManaged public var bedtimeDate: NSDate?
    
    /*
     * Midnight time set to 12AM.
     */
    @NSManaged public var midnightDate: NSDate?
    
    /*
     * Total hours worked for a night.
     */
    @NSManaged public var totalHours: Int32
    
    /*
     * Total pay charged every night of work.
     */
    @NSManaged public var totalPay: Double
    
    /*
     * Pay charged from start (5PM) to bedtime (10PM)
     */
    @NSManaged public var startToBedtimePay: Double
    
    /*
     * Pay charged from bedtime (10PM) to midnight (12AM)
     */
    @NSManaged public var bedtimeToMidnightPay: Double
    
    /*
     * Pay charged from midnight (12AM) to end (4AM)
     */
    @NSManaged public var midnightToEndPay: Double
    
    /*
     * Start of work  at 5PM.
     */
    @NSManaged public var startDate: NSDate?
    
    /*
     * End of work at 4AM the next day.
     */
    @NSManaged public var endDate: NSDate?

}
