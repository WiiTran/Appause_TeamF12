//  TeacherScheduleView.swift
//  Appause
//
//  Created by Rayanne Ohara on 9/17/24.
//  Edited by Rayanne Ohara 10/14/2014
//  Rewritten File:
//  Implements database to show and edit schedules
//  using faster editing with Firebase Firestore
//
import SwiftUI
import FirebaseFirestore

struct TeacherScheduleView: View {
    @State private var scheduleName = "Normal Schedule" // Editable schedule name
    @State private var schedules: [String] = [] // Schedules loaded from Firestore
    @State private var periods: [(classID: String, startTime: Date, endTime: Date)] = [] // [(ClassID, StartTime, EndTime)]
    @State private var editingMode = false // Flag to enable/disable editing mode
    @State private var newClassID = ""
    @State private var newStartTime = Date()
    @State private var newEndTime = Date()
    @State private var selectedPeriodIndex: Int?
    
    let maxPeriods = 9 // Set a limit for periods (0-8)

    var body: some View {
        NavigationView {
            VStack {
                if editingMode {
                    TextField("Schedule Name", text: $scheduleName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                } else {
                    Text(scheduleName)
                        .font(.title)
                        .padding()
                }

                Picker("Select Schedule", selection: $scheduleName) {
                    ForEach(schedules, id: \.self) { schedule in
                        Text(schedule)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: scheduleName, perform: { newSchedule in
                    loadSelectedSchedule(newSchedule)
                })

                List {
                    ForEach(periods.indices, id: \.self) { index in
                        HStack {
                            Text("Period \(index): \(periods[index].classID)")
                            Spacer()
                            Text("\(formattedTime(periods[index].startTime)) - \(formattedTime(periods[index].endTime))")
                        }
                        .onTapGesture {
                            selectedPeriodIndex = index
                            newClassID = periods[index].classID
                            newStartTime = periods[index].startTime
                            newEndTime = periods[index].endTime
                        }
                    }
                    .onDelete(perform: deletePeriod)
                }

                if editingMode {
                    VStack {
                        TextField("Class ID", text: $newClassID)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        DatePicker("Start Time", selection: $newStartTime, displayedComponents: .hourAndMinute)
                            .padding()

                        DatePicker("End Time", selection: $newEndTime, displayedComponents: .hourAndMinute)
                            .padding()

                        Button(action: {
                            if let selectedIndex = selectedPeriodIndex {
                                updatePeriod(at: selectedIndex)
                            } else {
                                addNewPeriod()
                            }
                        }) {
                            Text(selectedPeriodIndex != nil ? "Update Period" : "Add Period")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }

                Spacer()

                HStack {
                    Button(action: {
                        editingMode.toggle()
                        clearInputFields()
                    }) {
                        Text(editingMode ? "Cancel Edit" : "Edit Schedule")
                            .font(.headline)
                            .padding()
                            .background(editingMode ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        saveSchedule(scheduleName, periods)
                        editingMode = false
                    }) {
                        Text("Save")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .opacity(editingMode ? 1 : 0)

                    NavigationLink(destination: TeacherAddScheduleView()) {
                        Text("Add Schedule")
                            .font(.headline)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Teacher Schedule")
            .onAppear {
                loadSchedules()
                loadSelectedSchedule(scheduleName) // Load selected schedule on appear
            }
        }
    }

    // Load schedules from Firestore
    func loadSchedules() {
        let db = Firestore.firestore()
        db.collection("schedules").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading schedules: \(error)")
            } else {
                if let snapshot = snapshot {
                    self.schedules = snapshot.documents.map { $0.documentID }
                }
            }
        }
    }

    // Load the selected schedule from Firestore
    func loadSelectedSchedule(_ scheduleName: String) {
        let db = Firestore.firestore()
        db.collection("schedules").document(scheduleName).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                if let periodsData = data?["periods"] as? [[String: Any]] {
                    self.periods = periodsData.compactMap { periodDict in
                        guard let classID = periodDict["classID"] as? String,
                              let startTime = periodDict["startTime"] as? Timestamp,
                              let endTime = periodDict["endTime"] as? Timestamp else { return nil }
                        return (classID, startTime.dateValue(), endTime.dateValue())
                    }
                }
            } else {
                print("Error loading schedule: \(error?.localizedDescription ?? "Unknown error")")
                // Predefine Normal Schedule if no document exists
                if scheduleName == "Normal Schedule" {
                    periods = [
                        ("", date(from: "7:33 AM") ?? Date(), date(from: "8:25 AM") ?? Date()),
                        ("", date(from: "8:30 AM") ?? Date(), date(from: "9:21 AM") ?? Date()),
                        ("", date(from: "9:26 AM") ?? Date(), date(from: "10:17 AM") ?? Date()),
                        ("", date(from: "10:22 AM") ?? Date(), date(from: "11:13 AM") ?? Date()),
                        ("", date(from: "11:18 AM") ?? Date(), date(from: "12:09 PM") ?? Date()),
                        ("", date(from: "12:44 PM") ?? Date(), date(from: "1:35 PM") ?? Date()),
                        ("", date(from: "1:40 PM") ?? Date(), date(from: "2:31 PM") ?? Date()),
                        ("", date(from: "2:36 PM") ?? Date(), date(from: "3:27 PM") ?? Date()),
                        ("", date(from: "3:32 PM") ?? Date(), date(from: "4:22 PM") ?? Date())
                    ]
                }
            }
        }
    }

    func saveSchedule(_ scheduleName: String, _ newPeriods: [(String, Date, Date)]) {
        let db = Firestore.firestore()
        
        // Map periods to a format suitable for Firestore
        let periodData: [[String: Any]] = newPeriods.map { period in
            [
                "classID": period.0, // Access the first element of the tuple (classID)
                "startTime": Timestamp(date: period.1), // Access the second element of the tuple (startTime)
                "endTime": Timestamp(date: period.2) // Access the third element of the tuple (endTime)
            ]
        }
        
        // Update or create the schedule document in Firestore
        db.collection("schedules").document(scheduleName).setData([
            "periods": periodData,
            "isActive": true, // Set active flag or other necessary fields
            "name": scheduleName // Save the schedule name
        ]) { error in
            if let error = error {
                print("Error saving schedule: \(error.localizedDescription)")
            } else {
                print("Schedule saved successfully!")
                // Optionally: load or refresh data after saving
            }
        }
    }

    // Add a new period to the current schedule (limited to 9 periods)
    func addNewPeriod() {
        // Prevent adding duplicate period times
        if isDuplicateTime() {
            print("Cannot add period with duplicate time!")
            return
        }
        
        guard periods.count < maxPeriods else { return } // Limit periods to 0-8
        let newPeriod = (newClassID, newStartTime, newEndTime)
        periods.append(newPeriod)
        clearInputFields()
    }

    // Update an existing period
    func updatePeriod(at index: Int) {
        // Prevent adding duplicate period times
        if isDuplicateTime(excluding: index) {
            print("Cannot update period with duplicate time!")
            return
        }
        
        periods[index] = (newClassID, newStartTime, newEndTime)
        clearInputFields()
        selectedPeriodIndex = nil
    }

    // Delete a period
    func deletePeriod(at offsets: IndexSet) {
        periods.remove(atOffsets: offsets)
    }

    // Clear input fields after adding/updating
    func clearInputFields() {
        newClassID = ""
        newStartTime = Date()
        newEndTime = Date()
    }

    // Check for duplicate period times
    func isDuplicateTime(excluding index: Int? = nil) -> Bool {
        for (i, period) in periods.enumerated() {
            if i != index {
                if period.startTime == newStartTime || period.endTime == newEndTime {
                    return true
                }
            }
        }
        return false
    }

    // Date formatter for displaying time
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Format time as "hh:mm AM/PM"
        return formatter.string(from: date)
    }
    
    // Helper function to create a date from a string
    func date(from timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.date(from: timeString)
    }
}

struct TeacherScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherScheduleView()
    }
}
