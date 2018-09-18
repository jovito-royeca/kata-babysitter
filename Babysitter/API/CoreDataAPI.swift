//
//  CoreDataAPI.swift
//  Babysitter
//
//  Created by Jovito Royeca on 15.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import Sync

/*
 * Singleton class to manage Core Data operations.
 */
class CoreDataAPI: NSObject {
    static let sharedInstance = CoreDataAPI()
    
    // MARK: Variables
    /*
     * Uses SyncDB to simplify mapping JSON to Core Data.
     * This is the main context of Core Data and is used for saving and retrieving data.
     */
    fileprivate var _dataStack:DataStack?
    var dataStack:DataStack? {
        get {
            if _dataStack == nil {
                _dataStack = DataStack(modelName: "Babysitter")
            }
            return _dataStack
        }
        set {
            _dataStack = newValue
        }
    }
    
    /*
     * Save pending updates, if there is any.
     */
    func saveContext() {
        guard let dataStack = dataStack else {
            return
        }
        
        if dataStack.mainContext.hasChanges {
            do {
                try dataStack.mainContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /*
     * Save the defined Babysitter work.
     */
    func saveWork(startDate: NSDate,
                  bedtimeDate: NSDate,
                  midnightDate: NSDate,
                  endDate: NSDate,
                  startToBedtimePay: Double,
                  bedtimeToMidnightPay: Double,
                  midnightToEndPay: Double,
                  totalHours: Int32,
                  totalPay: Double) {
        
        guard let dataStack = dataStack,
            let desc = NSEntityDescription.entity(forEntityName: "WorkModel", in: dataStack.mainContext),
            let work = NSManagedObject(entity: desc, insertInto: dataStack.mainContext) as? WorkModel else {
                fatalError()
        }
        
        work.startDate = startDate
        work.bedtimeDate = bedtimeDate
        work.midnightDate = midnightDate
        work.endDate = endDate
        work.startToBedtimePay = startToBedtimePay
        work.bedtimeToMidnightPay = bedtimeToMidnightPay
        work.midnightToEndPay = midnightToEndPay
        work.totalHours = totalHours
        work.totalPay = totalPay
        
        try! dataStack.mainContext.save()
    }
    
    /*
     * Delete the Babysitter works from the date range in the parameters.
     */
    func deleteWork(startDate: NSDate,
                    endDate: NSDate) {
        
        guard let dataStack = dataStack else {
            return
        }
        
        let request: NSFetchRequest<WorkModel> = WorkModel.fetchRequest()
        request.predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", startDate, endDate)
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        let result = try! dataStack.mainContext.fetch(request)
        for object in result {
            dataStack.mainContext.delete(object)
        }
        
        try! dataStack.mainContext.save()
    }
    
    /*
     * Find Babysitter works from the date range in the parameters.
     */
    func findWorks(startDate: NSDate,
                  endDate: NSDate) -> [WorkModel] {
        
        guard let dataStack = dataStack else {
            return [WorkModel]()
        }
        
        let request: NSFetchRequest<WorkModel> = WorkModel.fetchRequest()
        request.predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", startDate, endDate)
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        let result = try! dataStack.mainContext.fetch(request)
        return result
    }
}
