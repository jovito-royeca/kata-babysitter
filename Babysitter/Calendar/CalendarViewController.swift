//
//  CalendarViewController.swift
//  Babysitter
//
//  Created by Jovito Royeca on 14.09.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import JKCalendar

/*
 * The main ViewController that displays the calendar.
 */
class CalendarViewController: UIViewController {
    // MARK: Variables
    let markColor = UIColor(red: 40/255, green: 178/255, blue: 253/255, alpha: 1)
    
    // handles data and business logic
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
        let work = viewModel.getWorkOnSelectedDate()
        
        switch indexPath.section {
        case 0:
            guard let c = tableView.dequeueReusableCell(withIdentifier: ActionTableViewCell.reuseIdentifier) as? ActionTableViewCell else {
                fatalError("ActionTableViewCell not found")
            }
            c.delegate = self
            c.dateLabel.text = viewModel.dateString()
            c.work = work
            cell = c

        default:
            guard let c = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.reuseIdentifier) as? TimeTableViewCell else {
                fatalError("TimeTableViewCell not found")
            }
            
            let hour = indexPath.row
            c.timeLabel.text = viewModel.hourString(hour: hour)
            c.bandView.backgroundColor = viewModel.hourEnabled(hour: hour) ? markColor : UIColor.clear
            c.descriptionLabel.text = viewModel.hourDescription(hour: hour)
            c.priceLabel.text = viewModel.hourPrice(hour: hour)
            cell = c
        }
        
        return cell!
    }
}

// MARK: UITableViewDelegate
extension CalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(0)
        
        switch indexPath.section {
        case 0:
            height = ActionTableViewCell.cellHeight
        case 1:
            height = TimeTableViewCell.cellHeight
        default:
            ()
        }

        return height
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
        
        // solid circle for the selected date
        if jkSelectedDate == month {
            marks.append(JKCalendarMark(type: .circle,
                                        day: jkSelectedDate,
                                        color: markColor))
        }
        
        // hollow circle for the current date
        marks.append(JKCalendarMark(type: .hollowCircle,
                                    day: jkCurrentDate,
                                    color: markColor))
        return marks
    }
    
    func calendar(_ calendar: JKCalendar, continuousMarksWith month: JKMonth) -> [JKCalendarContinuousMark]? {
        var marks = [JKCalendarContinuousMark]()
        
        // get the visible weeks
        guard let firstWeek = month.weeks().first,
            let lastWeek = month.weeks().last else {
            return marks
        }
        let startDay = firstWeek.sunday.date
        let endDay = lastWeek.staturday.date
        
        // get the Babysitter works from first visible day to last visible day
        guard let works = viewModel.findWorks(startDate: startDay,
                                              endDate: endDay) else {
            return marks
        }
        
        // create marks from Babysitter works
        for work in works {
            marks.append(JKCalendarContinuousMark(type: .dot,
                                                  start: JKDay(date: work.startDate! as Date),
                                                  end: JKDay(date: work.endDate! as Date),
                                                  color: markColor))
        }
     
        return marks
    }
}

// MARK: ActionTableViewCellDelegate
extension CalendarViewController : ActionTableViewCellDelegate {
    /*
     * Implements the Switch toggles. Displays a prompt if the Switch is off.
     */
    func babysitToggled(on: Bool) {
        if on {
            viewModel.saveWork()
            tableView.calendar.reloadData()
            tableView.reloadData()
        } else {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Delete this Babysitting work from \(viewModel.dateString()) ?",
                                                    preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .destructive,
                                             handler: { (action: UIAlertAction) in
                self.viewModel.deleteWork()
                self.tableView.calendar.reloadData()
                self.tableView.reloadData()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: { (action: UIAlertAction) in
                self.tableView.reloadData()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController,
                    animated: true,
                    completion: nil)
        }
    }
}


