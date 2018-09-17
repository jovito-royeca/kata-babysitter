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
    var work: WorkModel? {
        didSet {
            timeLabel.text = (hour < 10 ? "0": "") + "\(hour):00"
            bandView.backgroundColor = UIColor.clear
            descriptionLabel.text = " "
            priceLabel.text = " "
            
            guard let work = work,
                let startDate = work.startDate,
                let endDate = work.endDate,
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
            let newStartDate = calendar.date(from: components)
            
            components.day = calendar.component(.day, from: endDate as Date)
            let newEndDate = calendar.date(from: components)
            
            components.day = calendar.component(.day, from: date)
            let newDate = calendar.date(from: components)
            
            if newDate!.compare(newEndDate!) == .orderedSame {
                if hour > 0 && hour <= 4 {
                    bandView.backgroundColor = markColor
                    descriptionLabel.text = "Midnight To End"
                    priceLabel.text = String(format: "$%.2f", PayRate.midnightToEndRate.rawValue)
                }
            }
            
            if newDate!.compare(newStartDate!) == .orderedSame {
                if hour >= 17 && hour <= 21 {
                    bandView.backgroundColor = markColor
                    descriptionLabel.text = "Start to Bedtime"
                    priceLabel.text = String(format: "$%.2f", PayRate.startToBedtimeRate.rawValue)
                } else if hour >= 21 && hour <= 23 {
                    bandView.backgroundColor = markColor
                    descriptionLabel.text = "Bedtime to Midnight"
                    priceLabel.text = String(format: "$%.2f", PayRate.bedtimeToMidnightRate.rawValue)
                }
            }
        }
    }
    
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
    
    

}
