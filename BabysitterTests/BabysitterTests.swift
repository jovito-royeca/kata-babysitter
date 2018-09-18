//
//  BabysitterTests.swift
//  BabysitterTests
//
//  Created by Jovito Royeca on 14.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import XCTest
@testable import Babysitter

class BabysitterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /*
     * Test that we can create Babysitter works in the current month.
     */
    func testSaveWork() {
        // delete the works first from this month
        testDeleteWork()
        
        let viewModel = CalendarViewModel()
        
        // start of month
        let calendar = NSCalendar(identifier: .gregorian)!
        var components = calendar.components([.year, .month], from: Date())
        let startDate = calendar.date(from: components)!
        let firstDayOfMonth = calendar.component(.day, from: startDate)
        
        // end of month
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endDate = calendar.date(byAdding: comps2 as DateComponents, to: startDate, options: [])!
        let lastDayOfMonth = calendar.component(.day, from: endDate)
        
        // loop through the month and create Babysitter works
        for i in firstDayOfMonth...lastDayOfMonth {
            components.year = calendar.component(.year, from: startDate)
            components.month = calendar.component(.month, from: startDate)
            components.day = i
            viewModel.selectedDate = calendar.date(from: components)!
            viewModel.saveWork()
        }
        
        // check that we saved the works
        guard let results = viewModel.findWorks(startDate: startDate, endDate: endDate) else {
            XCTFail()
            return
        }
        
        // print the works
        for work in results {
            print("\(work.startDate!)-\(work.endDate!) = \(work.totalPay)")
        }
        
        // delete the created works first from this month
        testDeleteWork()
    }
    
    /*
     * Test that we can delete the Babysitter works in the current month.
     */
    
    func testDeleteWork() {
        let viewModel = CalendarViewModel()
        
        // start of month
        let calendar = NSCalendar(identifier: .gregorian)!
        var components = calendar.components([.year, .month], from: Date())
        let startDate = calendar.date(from: components)!
        let firstDayOfMonth = calendar.component(.day, from: startDate)
        
        // end of month
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endDate = calendar.date(byAdding: comps2 as DateComponents, to: startDate, options: [])!
        let lastDayOfMonth = calendar.component(.day, from: endDate)
        
        // loop through the month and create Babysitter works
        for i in firstDayOfMonth...lastDayOfMonth {
            components.year = calendar.component(.year, from: startDate)
            components.month = calendar.component(.month, from: startDate)
            components.day = i
            viewModel.selectedDate = calendar.date(from: components)!
            viewModel.deleteWork()
        }
        
        // check that we saved the works
        guard let results = viewModel.findWorks(startDate: startDate, endDate: endDate) else {
            XCTFail()
            return
        }
        
        // check that we have deleted all the saved works
        XCTAssert(results.count == 0)
        
    }
}
