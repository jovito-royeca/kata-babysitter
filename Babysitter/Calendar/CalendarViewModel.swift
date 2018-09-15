//
//  CalendarViewModel.swift
//  Babysitter
//
//  Created by Jovito Royeca on 14.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit

class CalendarViewModel: NSObject {
    // MARK: Variables
    var selectedDate = Date()
    var currentDate = Date()
    
    func hasWorkOn(date: Date) -> Bool {
        return false
    }
    
    // MARK: UITableView methods
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return [1, hasWorkOn(date: selectedDate) ? 12 : 0][section]
    }
    
    func createWork() {
        
    }
}
