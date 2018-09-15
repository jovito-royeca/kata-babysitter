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
    var selectDay: JKDay = JKDay(date: Date())
    
    // MARK: Outlets
    @IBOutlet weak var tableView: JKCalendarTableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the xview.
        tableView.calendar.delegate = self
        tableView.calendar.dataSource = self
        tableView.calendar.focusWeek = selectDay.weekOfMonth - 1
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.reuseIdentifier, for: indexPath) as? TimeTableViewCell else {
            fatalError("TimeTableViewCell not found")
        }

        let hour = indexPath.row
        cell.timeLabel.text = (hour < 10 ? "0": "") + String(hour) + ":00"
        cell.descriptionLabel.text = "This is a very long description indeed that may expand multiples lines. Let us see how it goes... blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah."
        return cell
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
        selectDay = day
        calendar.focusWeek = day < calendar.month ? 0: day > calendar.month ? calendar.month.weeksCount - 1: day.weekOfMonth - 1
        calendar.reloadData()
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
    
    func calendar(_ calendar: JKCalendar, marksWith month: JKMonth) -> [JKCalendarMark]? {
        
        let firstMarkDay: JKDay = JKDay(year: 2018, month: 1, day: 9)!
        let secondMarkDay: JKDay = JKDay(year: 2018, month: 1, day: 20)!
        
        var marks: [JKCalendarMark] = []
        if selectDay == month{
            marks.append(JKCalendarMark(type: .circle,
                                        day: selectDay,
                                        color: markColor))
        }
        if firstMarkDay == month{
            marks.append(JKCalendarMark(type: .underline,
                                        day: firstMarkDay,
                                        color: markColor))
        }
        if secondMarkDay == month{
            marks.append(JKCalendarMark(type: .hollowCircle,
                                        day: secondMarkDay,
                                        color: markColor))
        }
        return marks
    }
    
    func calendar(_ calendar: JKCalendar, continuousMarksWith month: JKMonth) -> [JKCalendarContinuousMark]?{
        let startDay: JKDay = JKDay(year: 2018, month: 1, day: 17)!
        let endDay: JKDay = JKDay(year: 2018, month: 1, day: 18)!
        
        return [JKCalendarContinuousMark(type: .dot,
                                         start: startDay,
                                         end: endDay,
                                         color: markColor)]
    }
    
}


