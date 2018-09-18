//
//  TimeTableViewCell.swift
//  Babysitter
//
//  Created by Jovito Royeca on 15.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TimeCell"
    
    let markColor = UIColor(red: 40/255, green: 178/255, blue: 253/255, alpha: 1)
    
    // MARK: Variables
    var hour = 0
    var date: Date?
    var work: WorkModel?
    var previousWork: WorkModel?
    
    // MARK: Outlets
    @IBOutlet weak var bandView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Custom methods
    func updateDisplay() {
        timeLabel.text = "\(hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)) \(hour >= 12 ? "PM" : "AM")"//(hour < 10 ? "0": "") + "\(hour):00"
        bandView.backgroundColor = UIColor.clear
        descriptionLabel.text = " "
        priceLabel.text = " "
        
//        guard let work = work,
//            let startDate = work.startDate,
//            let date = date else {
//            return
//        }
//
//        let calendar = NSCalendar(identifier: .gregorian)!
//        var components = DateComponents()
//
//        components.year = calendar.component(.year, from: startDate as Date)
//        components.month = calendar.component(.month, from: startDate as Date)
//        components.day = calendar.component(.day, from: startDate as Date)
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
//        guard let newStartDate = calendar.date(from: components) else {
//            return
//        }
//
//        components.day = calendar.component(.day, from: date)
//        guard let newDate = calendar.date(from: components) else {
//            return
//        }
        
        guard let date = date,
            let newDate = getCleanDate(from: date) else {
            return
        }
        
        if hour > 0 && hour <= 4 {
            if previousWork != nil && previousWork?.endDate != nil {
                if newDate.compare(getCleanDate(from: previousWork!.endDate! as Date)!) == .orderedSame {
                    bandView.backgroundColor = markColor
                    descriptionLabel.text = PayRate.midnightToEndRate.description
                    priceLabel.text = String(format: "$%.2f", PayRate.midnightToEndRate.rawValue)
                }
            }
            
        } else if hour >= 17 && hour <= 21 {
            if work != nil && work?.startDate != nil {
                if newDate.compare(getCleanDate(from: work!.startDate! as Date)!) == .orderedSame {
                    bandView.backgroundColor = markColor
                    descriptionLabel.text = PayRate.startToBedtimeRate.description
                    priceLabel.text = String(format: "$%.2f", PayRate.startToBedtimeRate.rawValue)
                }
            }
        } else if hour >= 21 && hour <= 23 {
            if work != nil && work?.startDate != nil {
                if newDate.compare(getCleanDate(from: work!.startDate! as Date)!) == .orderedSame {
                    bandView.backgroundColor = markColor
                    descriptionLabel.text = PayRate.bedtimeToMidnightRate.description
                    priceLabel.text = String(format: "$%.2f", PayRate.bedtimeToMidnightRate.rawValue)
                }
            }
        }
    }
    
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

}
