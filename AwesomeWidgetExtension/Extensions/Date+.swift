//
//  Date+.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import Foundation

let Months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
let ShotMonths: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

let Weekdays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
let ShotWeekdays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

struct DateInfo {
    var year: String
    var month: String
    var day: String
    var weekday: String
}

var dateInfo: DateInfo {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .weekday], from: Date())

    let year = "\(components.year!)"
    let month = Months[components.month! - 1]
    let day = "\(components.day!)"
    let weekday = ShotWeekdays[components.weekday! - 1] // 星期几（注意，周日是“1”，周一是“2”。。。。）
    return DateInfo(year: year, month: month, day: day, weekday: weekday)
}
