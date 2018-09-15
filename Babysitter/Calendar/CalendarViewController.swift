//
//  CalendarViewController.swift
//  Babysitter
//
//  Created by Jovito Royeca on 14.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import JKCalendar

class CalendarViewController: UIViewController {
    // MARK: Variables
    let markColor = UIColor(red: 40/255, green: 178/255, blue: 253/255, alpha: 1)
    var viewModel = CalendarViewModel()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: JKCalendarTableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the xview.
        tableView.calendar.delegate = self
        tableView.calendar.dataSource = self
        tableView.calendar.focusWeek = JKDay(date: viewModel.selectedDate).weekOfMonth - 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: UITableViewDataSource
extension CalendarViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch indexPath.section {
        case 0:
            guard let c = tableView.dequeueReusableCell(withIdentifier: ActionTableViewCell.reuseIdentifier) as? ActionTableViewCell else {
                fatalError("ActionTableViewCell not found")
            }
            c.delegate = self
            c.babysitSwitch.isOn = viewModel.hasWorkOn(date: viewModel.selectedDate)
            cell = c

        default:
            guard let c = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.reuseIdentifier) as? TimeTableViewCell else {
                fatalError("TimeTableViewCell not found")
            }
            
            let hour = indexPath.row * 2
            c.timeLabel.text = (hour < 10 ? "0": "") + String(hour) + ":00"
            c.descriptionLabel.text = "This is a very long description indeed that may expand multiples lines. Let us see how it goes... blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah."
            cell = c
        }
        
        
        return cell!
    }
}

// MARK: UITableViewDelegate
extension CalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: JKCalendarDelegate
extension CalendarViewController: JKCalendarDelegate {
    
    func calendar(_ calendar: JKCalendar, didTouch day: JKDay){
        viewModel.selectedDate = day.date
        calendar.focusWeek = day < calendar.month ? 0: day > calendar.month ? calendar.month.weeksCount - 1: day.weekOfMonth - 1
        calendar.reloadData()
        tableView.reloadData()
    }
    
    func heightOfFooterView(in claendar: JKCalendar) -> CGFloat{
        return 10
    }
    
    func viewOfFooter(in calendar: JKCalendar) -> UIView?{
        let view = UIView()
        let line = UIView(frame: CGRect(x: 8, y: 9, width: calendar.frame.width - 16, height: 1))
        line.backgroundColor = UIColor.lightGray
        view.addSubview(line)
        return view
    }
}

// MARK: JKCalendarDataSource
extension CalendarViewController : JKCalendarDataSource {
    
    func calendar(_ calendar: JKCalendar, didPan days: [JKDay]) {
        viewModel.currentDate = Date()
        calendar.reloadData()
    }
    
    func calendar(_ calendar: JKCalendar, marksWith month: JKMonth) -> [JKCalendarMark]? {
        var marks: [JKCalendarMark] = []
        let jkSelectedDate = JKDay(date: viewModel.selectedDate)
        let jkCurrentDate = JKDay(date: viewModel.currentDate)
        
        if jkSelectedDate == month {
            marks.append(JKCalendarMark(type: .circle,
                                        day: jkSelectedDate,
                                        color: markColor))
        }
        
        marks.append(JKCalendarMark(type: .hollowCircle,
                                    day: jkCurrentDate,
                                    color: markColor))
        return marks
    }
    
    func calendar(_ calendar: JKCalendar, continuousMarksWith month: JKMonth) -> [JKCalendarContinuousMark]?{
        let startDay: JKDay = JKDay(year: month.year, month: month.month, day: month.firstDay.day + 5)!
        let endDay: JKDay = JKDay(year: month.year, month: month.month, day: month.lastDay.day / 2)!
        
        return [JKCalendarContinuousMark(type: .dot,
                                         start: startDay,
                                         end: endDay,
                                         color: markColor)]
    }
    
}

// MARK:
extension CalendarViewController : ActionTableViewCellDelegate {
    func babysitToggled(on: Bool) {
        if on {
            
        } else {
            
        }
    }
}


