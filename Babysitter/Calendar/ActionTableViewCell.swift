//
//  ActionTableViewCell.swift
//  Babysitter
//
//  Created by Jovito Royeca on 15.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit

protocol ActionTableViewCellDelegate : NSObjectProtocol {
    func babysitToggled(on: Bool)
}

class ActionTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ActionCell"
    
    // MARK: Variables
    var delegate: ActionTableViewCellDelegate?
    var work: WorkModel? {
        didSet {
            if work != nil {
                babysitSwitch.isOn = true
                hoursLabel.text = "\(work!.totalHours)"
                payLabel.text = String(format: "$%.2f", work!.totalPay)
            } else {
                babysitSwitch.isOn = false
                hoursLabel.text = "0"
                payLabel.text = String(format: "$%.2f", 0)
            }
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var babysitSwitch: UISwitch!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    
    // MARK: Actions
    @IBAction func babysitAction(_ sender: UISwitch) {
        delegate?.babysitToggled(on: sender.isOn)
    }
    
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
