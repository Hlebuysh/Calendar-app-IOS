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
    
    private var choiceTable = [String]()
    
    private var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isScrollEnabled = true
        
        yearButton.setTitle(String(Calendar.current.component(.year, from: Date())), for: .normal)
        monthButton.setTitle(months[Calendar.current.component(.month, from: Date()) - 1], for: .normal)
        
        
        eventsTable.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCellPrototype")
        
        print(navigationController?.viewControllers.count ?? "No")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FromCalendarToEvent" else { return }
        guard let destination = segue.destination as? EventViewController else { return }
        destination.event = events[eventsTable.indexPathForSelectedRow!.row]
    }
    
    @IBAction private func choiceYear(_ sender: Any) {
        choiceTable.removeAll()
        for year in Calendar.current.component(.year, from: Date())...(Calendar.current.component(.year, from: Date())+10){
            choiceTable.append(String(year))
        }
        selectedButton = yearButton
        addTransporentView(x: Int(buttonStack.frame.origin.x) + Int(yearButton.frame.origin.x), y: Int(buttonStack.frame.origin.y) + Int(yearButton.frame.origin.y) + Int(yearButton.frame.height), width: Int(yearButton.frame.width))
    }
    @IBAction private func choiceMonth(_ sender: Any) {
        choiceTable.removeAll()
        if (Int(yearButton.title(for: .normal)!) == Calendar.current.component(.year, from: Date())){
            for month in (Calendar.current.component(.month, from: Date())-1)...11{
                choiceTable.append(months[month])
            }
        }else{
            choiceTable = months
        }
        selectedButton = monthButton
        addTransporentView(x: Int(buttonStack.frame.origin.x) + Int(monthButton.frame.origin.x), y: Int(buttonStack.frame.origin.y) + Int(monthButton.frame.origin.y) + Int(monthButton.frame.height), width: Int(monthButton.frame.width))
    }
}

extension CalendarViewController{
    private func addTransporentView(x:Int, y:Int, width:Int){
        let window = UIApplication.shared.keyWindow
        transporentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transporentView)

        tableView.frame = CGRect(x: x, y: y, width: width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5

        isActiveButton = true

        transporentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransporentView))
        transporentView.addGestureRecognizer(tapGesture)
        transporentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transporentView.alpha = 0.5

            self.tableView.frame=CGRect(x: x, y: y+5, width: width, height: self.choiceTable.count * 40 > 300 ? 300 : self.choiceTable.count * 40)

        }, completion: nil)
    }
    @objc private func removeTransporentView(){
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transporentView.alpha = 0

            self.tableView.frame=CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)

        }, completion: nil)
        isActiveButton = false
    }
}


extension CalendarViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = choiceTable[indexPath.row]
            return cell
        }
        else{
//            events = getUserEvents(uid: Auth.auth().currentUser!.uid)
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCellPrototype", for: indexPath) as! EventCell
            print(events.count)
            print(indexPath.row)
            cell.titleLable?.text = events[indexPath.row].title
            cell.descriptionLable?.text = events[indexPath.row].startTime+" - "+events[indexPath.row].endTime
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return choiceTable.count
        }
        else{
            return events.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            return 40
        }
        else{
            return 80
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            selectedButton.setTitle(choiceTable[indexPath.row], for: .normal)
            removeTransporentView()
            changeDateOnCalendar()
        }
        else{
//            let currentCell = tableView.cellForRow(at: indexPath) as! EventCell
            performSegue(withIdentifier: "FromCalendarToEvent", sender: self)
//            if currentCell.informationField.backgroundColor == UIColor.lightGray{
//                currentCell.informationField.backgroundColor = UIColor.darkGray
//            }
//            else{
//                performSegue(withIdentifier: "FromCalendarToEvent", sender: self)
//                currentCell.informationField.backgroundColor = UIColor.lightGray
//            }
        }
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

