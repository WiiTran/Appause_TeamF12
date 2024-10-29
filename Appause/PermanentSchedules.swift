//
//  PermanentSchedules.swift
//  Appause
//
//  Created by Rayanne Ohara on 10/23/24.
//

import Foundation
struct Period {
    let id: Int
    let name: String
    let startTime: String
    let endTime: String
}

struct PermanentSchedules {
    static let Regular: [Period] = [
        Period(id: 0, name: "", startTime: "7:33 AM", endTime: "8:25 AM"),
        Period(id: 1, name: "", startTime: "8:30 AM", endTime: "9:21 AM"),
        Period(id: 2, name: "", startTime: "9:26 AM", endTime: "10:17 AM"),
        Period(id: 3, name: "", startTime: "10:22 AM", endTime: "11:13 AM"),
        Period(id: 4, name: "", startTime: "11:18 AM", endTime: "12:09 PM"),
        Period(id: 5, name: "Lunch", startTime: "12:09 PM", endTime: "12:39 PM"),
        Period(id: 6, name: "", startTime: "12:44 PM", endTime: "1:35 PM"),
        Period(id: 7, name: "", startTime: "1:40 PM", endTime: "2:31 PM"),
        Period(id: 8, name: "", startTime: "2:36 PM", endTime: "3:27 PM"),
        Period(id: 9, name: "", startTime: "3:32 PM", endTime: "4:22 PM")
    ]

    static let MinimumDay: [Period] = [
        Period(id: 0, name: "", startTime: "7:45 AM", endTime: "8:25 AM"),
        Period(id: 1, name: "", startTime: "8:30 AM", endTime: "9:05 AM"),
        Period(id: 2, name: "", startTime: "9:10 AM", endTime: "9:45 AM"),
        Period(id: 3, name: "", startTime: "9:50 AM", endTime: "10:25 AM"),
        Period(id: 4, name: "Break", startTime: "10:25 AM", endTime: "10:35 AM"),
        Period(id: 5, name: "", startTime: "10:40 AM", endTime: "11:15 AM"),
        Period(id: 6, name: "", startTime: "11:20 AM", endTime: "11:55 AM"),
        Period(id: 7, name: "", startTime: "12:00 PM", endTime: "12:35 PM"),
        Period(id: 8, name: "", startTime: "12:40 PM", endTime: "1:15 PM"),
        Period(id: 9, name: "", startTime: "1:20 PM", endTime: "1:55 PM")
    ]

    static let Thursday: [Period] = [
        Period(id: 0, name: "", startTime: "7:47 AM", endTime: "8:25 AM"),
        Period(id: 1, name: "", startTime: "8:30 AM", endTime: "9:08 AM"),
        Period(id: 2, name: "", startTime: "9:13 AM", endTime: "9:51 AM"),
        Period(id: 3, name: "", startTime: "9:56 AM", endTime: "10:34 AM"),
        Period(id: 4, name: "", startTime: "10:39 AM", endTime: "11:17 AM"),
        Period(id: 5, name: "Lunch", startTime: "11:17 AM", endTime: "11:47 AM"),
        Period(id: 6, name: "", startTime: "11:52 AM", endTime: "12:30 PM"),
        Period(id: 7, name: "", startTime: "12:35 PM", endTime: "1:13 PM"),
        Period(id: 8, name: "", startTime: "1:18 PM", endTime: "1:56 PM"),
        Period(id: 9, name: "", startTime: "2:01 PM", endTime: "2:39 PM")
    ]

    static let Rally: [Period] = [
        Period(id: 0, name: "", startTime: "7:33 AM", endTime: "8:25 AM"),
        Period(id: 1, name: "", startTime: "8:30 AM", endTime: "9:15 AM"),
        Period(id: 2, name: "", startTime: "9:20 AM", endTime: "10:05 AM"),
        Period(id: 3, name: "", startTime: "10:10 AM", endTime: "10:55 AM"),
        Period(id: 4, name: "", startTime: "11:00 AM", endTime: "11:45 AM"),
        Period(id: 5, name: "Rally/Spartan Time", startTime: "11:45 AM", endTime: "12:27 PM"),
        Period(id: 6, name: "Lunch", startTime: "12:27 PM", endTime: "12:57 PM"),
        Period(id: 7, name: "", startTime: "1:02 PM", endTime: "1:47 PM"),
        Period(id: 8, name: "", startTime: "1:52 PM", endTime: "2:37 PM"),
        Period(id: 9, name: "", startTime: "2:42 PM", endTime: "3:27 PM")
    ]

    static let Finals: [Period] = [
        Period(id: 1, name: "", startTime: "8:30 AM", endTime: "10:35 AM"),
        Period(id: 2, name: "Lunch", startTime: "10:35 AM", endTime: "11:05 AM"),
        Period(id: 3, name: "", startTime: "11:10 AM", endTime: "1:15 PM")
    ]

    static func getSchedule(_ scheduleName: String) -> [Period]? {
        switch scheduleName {
        case "Regular": return Regular
        case "Minimum Day": return MinimumDay
        case "Thursday": return Thursday
        case "Rally": return Rally
        case "Finals": return Finals
        default: return nil
        }
    }
}
