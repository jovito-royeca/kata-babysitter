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

    // MARK: Variables
    var hour = 0
    var date: Date?
    var work: WorkModel? {
        didSet {
            timeLabel.text = (hour < 10 ? "0": "") + "\(hour):00"
            bandView.backgroundColor = UIColor.clear
            descriptionLabel.text = " "
            
            guard let work = work,
                let startDate = work.startDate,
                let date = date else {
                return
            }
            
            let calendar = NSCalendar(identifier: .gregorian)!
            var components = DateComponents()
            
            components.year = calendar.component(.year, from: startDate as Date)
            components.month = calendar.component(.month, from: startDate as Date)
            components.day = calendar.component(.day, from: startDate as Date)
            components.hour = 0
            components.minute = 0
            components.second = 0
            let newStartDate = calendar.date(from: components)!
            
            components.year = calendar.component(.year, from: date)
            components.month = calendar.component(.month, from: date)
            components.day = calendar.component(.day, from: date)
            components.hour = 0
            components.minute = 0
            components.second = 0
            let newDate = calendar.date(from: components)!
            
            if newDate.compare(newStartDate) == .orderedSame {
            if hour >= 17 && hour <= 19 {
                bandView.backgroundColor = UIColor.orange
                descriptionLabel.text = String(format: "$%.2f / hour", PayRate.startToBedtimeRate.rawValue)
            } else if hour >= 19 && hour <= 23 {
                bandView.backgroundColor = UIColor.orange
                descriptionLabel.text = String(format: "$%.2f / hour", PayRate.bedtimeToMidnightRate.rawValue)
            } else if hour > 0 && hour <= 4 {
                bandView.backgroundColor = UIColor.orange
                descriptionLabel.text = String(format: "$%.2f / hour", PayRate.midnightToEndRate.rawValue)
            }
            }
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var bandView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
