//  TeacherScheduleView.swift
//  Appause
//
//  Created by Rayanne Ohara on 9/17/24.
//  Edited by Rayanne Ohara 10/14/2014
//  Edited by Rayanne Ohara 10/25/2024
//  Edited by Rayanne Ohara 10/27/2024
//  Edited by Rayanne Ohara 10/28/2024
//  Rewritten File:
//  Implements database to show and edit schedules
//  using faster editing with Firebase Firestore
//
import SwiftUI
import FirebaseFirestore

struct TeacherScheduleView: View {
    @State private var scheduleName = "Regular" // Default selected schedule name
    @State private var schedules: [String] = ["Regular", "Thursday", "Minimum Day", "Rally", "Finals"] // List of available schedules
    @State private var periods: [SchedulePeriod] = [] // List of periods for the selected schedule
    @State private var editingMode = false // Indicates if the user is editing the schedule
    @State private var newClassID = "" // Name of the class for adding/editing periods
    @State private var newStartTime = Date() // Start time for adding/editing periods
    @State private var newEndTime = Date() // End time for adding/editing periods
    @State private var selectedPeriodIndex: Int? // Selected period index for editing

    var body: some View {
        NavigationView {
            VStack {
                // Display selected schedule name
                Text(scheduleName)
                    .font(.title)
                    .padding()

                // Dropdown menu to select a schedule
                Picker("Select Schedule", selection: $scheduleName) {
                    ForEach(schedules, id: \.self) { schedule in
                        Text(schedule)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: scheduleName) { newSchedule in
                    loadSchedule(newSchedule)
                }

                // List displaying periods in the selected schedule
                List {
                    ForEach(periods.indices, id: \.self) { index in
                        HStack {
                            Text("Period \(index + 1): \(periods[index].name)")
                            Spacer()
                            Text("\(periods[index].startTime) - \(periods[index].endTime)")
                        }
                    }
                }

                Spacer()

                // Save button to save custom schedules to Firestore
                Button(action: {
                    saveSchedule(scheduleName, periods)
                }) {
                    Text("Save Custom Schedule")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Teacher Schedule")
            .onAppear {
                loadSchedule(scheduleName) // Load the initial schedule when the view appears
            }
        }
    }

    // Loads the selected schedule; first checks if it's a permanent schedule
    func loadSchedule(_ scheduleName: String) {
        if let permanentPeriods = ScheduleDatabaseManager.shared.loadPermanentSchedule(scheduleName) {
            periods = permanentPeriods
        } else {
            ScheduleDatabaseManager.shared.loadCustomSchedule(scheduleName) { loadedPeriods in
                periods = loadedPeriods ?? []
            }
        }
    }

    // Saves a custom schedule to Firestore if modified
    func saveSchedule(_ scheduleName: String, _ periods: [SchedulePeriod]) {
        ScheduleDatabaseManager.shared.saveCustomSchedule(scheduleName, periods: periods)
    }
}

struct TeacherScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherScheduleView()
    }
}
