//
//  TransporentView.swift
//  Calendar
//
//  Created by User on 22.11.2022.
//

import UIKit

class DropDownView {
    
    private struct Month{
        var name: String
        private var maxDay: Int
        init(_ name: String, _ maxDay: Int) {
            self.name = name
            self.maxDay = maxDay
        }
        func getMaxDay(year: Int) -> Int{
            if (self.name != "Февраль") || !(year%400 == 0 || (year%100 != 0 && year%4 == 0)){
                return self.maxDay
            }
            return self.maxDay + 1
        }
    }
    
    private let months: [Month] = [Month("Январь", 31),
                                   Month("Февраль", 28),
                                   Month("Март", 31),
                                   Month("Апрель", 30),
                                   Month("Май", 31),
                                   Month("Июнь", 30),
                                   Month("Июль", 31),
                                   Month("Август", 31),
                                   Month("Сентябрь", 30),
                                   Month("Октябрь", 31),
                                   Month("Ноябрь", 31),
                                   Month( "Декабрь", 30)]
    private var transporentView: UIView
    var tableView: UITableView
    private var tapGesture: UITapGestureRecognizer
    
    init(superVC: UIViewController) {
        
        self.tapGesture = UITapGestureRecognizer(target: superVC, action: #selector(self.closeTransporentView(_:)))
        
        transporentView = UIView()
        self.transporentView.frame = UIApplication.shared.keyWindow?.frame ?? superVC.view.frame
        superVC.view.addSubview(self.transporentView)
        self.transporentView.addGestureRecognizer(tapGesture)
        self.transporentView.alpha = 0
        
        tableView = UITableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.isScrollEnabled = true
        tableView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        superVC.view.addSubview(self.tableView)
        tableView.layer.cornerRadius = 5
        
        
    }
}

extension DropDownView{
    func openTransporentView(data: [String], x: Int, y: Int, width: Int){
        
        self.tableView.reloadData()
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transporentView.alpha = 0.5

            self.tableView.frame=CGRect(x: x, y: y+5, width: width, height: data.count * 40 > 300 ? 300 : data.count * 40)

        }, completion: nil)
    }
    @objc func closeTransporentView(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transporentView.alpha = 0

            self.tableView.frame=CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: 0)

        }, completion: nil)
    }
}

extension DropDownView{
    func getYears() -> [String]{
        var years: [String] = []
        for year in Calendar.current.component(.year, from: Date())...(Calendar.current.component(.year, from: Date())+10){
            years.append(String(year))
        }
        return years
    }
    func getMonth(year: String) -> [String]{
        var months: [String] = []
        for month in self.months{
            months.append(month.name)
        }
        return months
    }
    func getDays(year: String, month: String) -> [String]{
        var days: [String] = []
        var startDay: Int = 1
        if (Int(year) == Calendar.current.component(.month, from: Date())) && (findMonth(month: month) == Calendar.current.component(.month, from: Date())){
            startDay = Calendar.current.component(.day, from: Date())
        }
        for day in startDay...months[findMonth(month: month)].getMaxDay(year: Int(year)!){
            days.append(String(day))
        }
        return days
    }
    private func findMonth(month: String) -> Int{
        for i in 0...11{
            if months[i].name == month{
                return (i + 1)
            }
        }
        return 0
    }
}
