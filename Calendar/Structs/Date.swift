//
//  Month.swift
//  Calendar
//
//  Created by User on 19.12.2022.
//

import Foundation

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

func getYears() -> [String]{
    var years: [String] = []
    for year in Calendar.current.component(.year, from: Date())...(Calendar.current.component(.year, from: Date())+10){
        years.append(String(year))
    }
    return years
}
func getMonth(year: String) -> [String]{
    var _months: [String] = []
    for month in months{
        _months.append(month.name)
    }
    return _months
}
func getDays(year: String, month: String) -> [String]{
    var days: [String] = []
    var startDay: Int = 1
    if (Int(year) == Calendar.current.component(.year, from: Date())) && (findMonth(month: month) == Calendar.current.component(.month, from: Date())){
        startDay = Calendar.current.component(.day, from: Date())
    }
    for day in startDay...months[findMonth(month: month) - 1].getMaxDay(year: Int(year)!){
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
