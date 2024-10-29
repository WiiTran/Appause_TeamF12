//
//  PermanentSchedules.swift
//  Appause
//
//  Created by Rayanne Ohara on 10/23/24.
//
import Foundation

// Define the SchedulePeriod struct to represent each period in the schedule
struct SchedulePeriod {
    let name: String       // Name of the period (e.g., "Period 1", "Lunch")
    let startTime: String  // Start time in "hh:mm a" format
    let endTime: String    // End time in "hh:mm a" format
}

// Define PermanentSchedules with predefined schedules
struct PermanentSchedules {
    // Regular Schedule (every day except Thursday)
    static let regular: [SchedulePeriod] = [
        SchedulePeriod(name: "Period 0", startTime: "7:33 AM", endTime: "8:25 AM"),
        SchedulePeriod(name: "Period 1", startTime: "8:30 AM", endTime: "9:21 AM"),
        SchedulePeriod(name: "Period 2", startTime: "9:26 AM", endTime: "10:17 AM"),
        SchedulePeriod(name: "Period 3", startTime: "10:22 AM", endTime: "11:13 AM"),
        SchedulePeriod(name: "Period 4", startTime: "11:18 AM", endTime: "12:09 PM"),
        SchedulePeriod(name: "Lunch", startTime: "12:09 PM", endTime: "12:39 PM"),
        SchedulePeriod(name: "Period 5", startTime: "12:44 PM", endTime: "1:35 PM"),
        SchedulePeriod(name: "Period 6", startTime: "1:40 PM", endTime: "2:31 PM"),
        SchedulePeriod(name: "Period 7", startTime: "2:36 PM", endTime: "3:27 PM"),
        SchedulePeriod(name: "Period 8", startTime: "3:32 PM", endTime: "4:22 PM")
    ]

    // Minimum Day Schedule
    static let minimumDay: [SchedulePeriod] = [
        SchedulePeriod(name: "Period 0", startTime: "7:45 AM", endTime: "8:25 AM"),
        SchedulePeriod(name: "Period 1", startTime: "8:30 AM", endTime: "9:05 AM"),
        SchedulePeriod(name: "Period 2", startTime: "9:10 AM", endTime: "9:45 AM"),
        SchedulePeriod(name: "Period 3", startTime: "9:50 AM", endTime: "10:25 AM"),
        SchedulePeriod(name: "Break", startTime: "10:25 AM", endTime: "10:35 AM"),
        SchedulePeriod(name: "Period 4", startTime: "10:40 AM", endTime: "11:15 AM"),
        SchedulePeriod(name: "Period 5", startTime: "11:20 AM", endTime: "11:55 AM"),
        SchedulePeriod(name: "Period 6", startTime: "12:00 PM", endTime: "12:35 PM"),
        SchedulePeriod(name: "Period 7", startTime: "12:40 PM", endTime: "1:15 PM"),
        SchedulePeriod(name: "Period 8", startTime: "1:20 PM", endTime: "1:55 PM")
    ]

    // Thursday Schedule (except finals days)
    static let thursday: [SchedulePeriod] = [
        SchedulePeriod(name: "Period 0", startTime: "7:47 AM", endTime: "8:25 AM"),
        SchedulePeriod(name: "Period 1", startTime: "8:30 AM", endTime: "9:08 AM"),
        SchedulePeriod(name: "Period 2", startTime: "9:13 AM", endTime: "9:51 AM"),
        SchedulePeriod(name: "Period 3", startTime: "9:56 AM", endTime: "10:34 AM"),
        SchedulePeriod(name: "Period 4", startTime: "10:39 AM", endTime: "11:17 AM"),
        SchedulePeriod(name: "Lunch", startTime: "11:17 AM", endTime: "11:47 AM"),
        SchedulePeriod(name: "Period 5", startTime: "11:52 AM", endTime: "12:30 PM"),
        SchedulePeriod(name: "Period 6", startTime: "12:35 PM", endTime: "1:13 PM"),
        SchedulePeriod(name: "Period 7", startTime: "1:18 PM", endTime: "1:56 PM"),
        SchedulePeriod(name: "Period 8", startTime: "2:01 PM", endTime: "2:39 PM")
    ]

    // Rally/Spartan Time Schedule
    static let rally: [SchedulePeriod] = [
        SchedulePeriod(name: "Period 0", startTime: "7:33 AM", endTime: "8:25 AM"),
        SchedulePeriod(name: "Period 1", startTime: "8:30 AM", endTime: "9:15 AM"),
        SchedulePeriod(name: "Period 2", startTime: "9:20 AM", endTime: "10:05 AM"),
        SchedulePeriod(name: "Period 3", startTime: "10:10 AM", endTime: "10:55 AM"),
        SchedulePeriod(name: "Period 4", startTime: "11:00 AM", endTime: "11:45 AM"),
        SchedulePeriod(name: "Rally/Spartan Time", startTime: "11:45 AM", endTime: "12:27 PM"),
        SchedulePeriod(name: "Lunch", startTime: "12:27 PM", endTime: "12:57 PM"),
        SchedulePeriod(name: "Period 5", startTime: "1:02 PM", endTime: "1:47 PM"),
        SchedulePeriod(name: "Period 6", startTime: "1:52 PM", endTime: "2:37 PM"),
        SchedulePeriod(name: "Period 7", startTime: "2:42 PM", endTime: "3:27 PM"),
        SchedulePeriod(name: "Period 8", startTime: "3:32 PM", endTime: "4:22 PM")
    ]

    // Finals Schedule for Periods 1-6
    static let finals: [SchedulePeriod] = [
        SchedulePeriod(name: "Periods 1/2/3", startTime: "8:30 AM", endTime: "10:35 AM"),
        SchedulePeriod(name: "Lunch", startTime: "10:35 AM", endTime: "11:05 AM"),
        SchedulePeriod(name: "Periods 4/5/6", startTime: "11:10 AM", endTime: "1:15 PM")
    ]
}
