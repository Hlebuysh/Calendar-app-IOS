//
//  CalendarViewController.swift
//  Calendar
//
//  Created by User on 01.11.2022.
//

import UIKit
import FSCalendar
//import Firebase

class CalendarViewController: UIViewController {
    
    @IBOutlet weak private var buttonStack: UIStackView!
    @IBOutlet weak private var yearButton: UIButton!
    @IBOutlet weak private var monthButton: UIButton!
    
    
    @IBOutlet weak private var calendarTable: FSCalendar!
    
    @IBOutlet weak private var eventsTable: UITableView!
    
    private let months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    
    private let transporentView = UIView()
    private let tableView = UITableView()
    
    private var selectedButton = UIButton()
    private var isActiveButton:Bool = false
    
    private var dropDown: DropDown!
    
    private var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown = DropDown(superVC: self, selection: changeButtonTitle(title:))
        
        yearButton.setTitle(String(Calendar.current.component(.year, from: Date())), for: .normal)
        monthButton.setTitle(months[Calendar.current.component(.month, from: Date()) - 1], for: .normal)
        eventsTable.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCellPrototype")
        events = getEventsByDate(date: Date())
        eventsTable.reloadData()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FromCalendarToEvent" else { return }
        guard let destination = segue.destination as? EventViewController else { return }
        destination.event = events[eventsTable.indexPathForSelectedRow!.row]
    }
    
    @IBAction private func choiceYear(_ sender: Any) {
        selectedButton = yearButton
        dropDown.updateData(data: getYears())
        dropDown.openTransporentView(
            x: Int(buttonStack.frame.origin.x) + Int(yearButton.frame.origin.x),
            y: Int(buttonStack.frame.origin.y) + Int(yearButton.frame.origin.y) + Int(yearButton.frame.height),
            width: Int(yearButton.frame.width)
        )
    }
    @IBAction private func choiceMonth(_ sender: Any) {
        selectedButton = monthButton
        dropDown.updateData(data: getMonth(year: yearButton.title(for: .normal)!))
        dropDown.openTransporentView(
            x: Int(buttonStack.frame.origin.x) + Int(monthButton.frame.origin.x),
            y: Int(buttonStack.frame.origin.y) + Int(monthButton.frame.origin.y) + Int(monthButton.frame.height),
            width: Int(monthButton.frame.width)
        )
    }
}

extension CalendarViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCellPrototype", for: indexPath) as! EventCell
        cell.titleLable?.text = events[indexPath.row].title
        cell.descriptionLable?.text = events[indexPath.row].startTime+" - "+events[indexPath.row].endTime
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FromCalendarToEvent", sender: self)
    }
}

extension CalendarViewController: FSCalendarDelegate{
    private func changeDateOnCalendar(){
        let selectedDayComponents = DateComponents(
            calendar: nil,
            timeZone: TimeZone(secondsFromGMT: 60*60*3),
            era: nil,
            year: Int(yearButton.title(for: .normal)!),
            month: (months.firstIndex(of: monthButton.title(for: .normal)!) ?? 0) + 1,
            day: Calendar.current.component(.day, from: calendarTable.selectedDate ?? Date()),
            hour: 0,
            minute: 0,
            second: 0,
            nanosecond: nil,
            weekday: nil,
            weekdayOrdinal: nil,
            quarter: nil,
            weekOfMonth: nil,
            weekOfYear: nil,
            yearForWeekOfYear: nil)
        let selectedDay = Calendar.current.date(from: selectedDayComponents)
        calendarTable.select(selectedDay)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        yearButton.setTitle(String(Calendar.current.component(.year, from: date)), for: .normal)
        monthButton.setTitle(months[Calendar.current.component(.month, from: date) - 1], for: .normal)
        events = getEventsByDate(date: calendarTable.selectedDate ?? Date())
        eventsTable.reloadData()
    }
}
extension CalendarViewController:FSCalendarDataSource{
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date().addingTimeInterval((24*60*60)*365*10+2)
    }
}

extension CalendarViewController{
    func changeButtonTitle(title: String){
        selectedButton.setTitle(title, for: .normal)
    }
}
