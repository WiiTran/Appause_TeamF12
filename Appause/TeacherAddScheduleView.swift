//
//  TeacherAddScheduleView.swift
//  Appause
//
//  Created by Rayanne Ohara on 10/14/24.
//  Adds the ability to add new schedules
//
import SwiftUI
import FirebaseFirestore

struct TeacherAddScheduleView: View {
    @State private var newScheduleName = ""
    @State private var newPeriods: [(String, Date, Date)] = [] // [(ClassID, StartTime, EndTime)]
    
    @State private var classID = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    @State private var selectedPeriodIndex: Int? // Selected period index for editing
    @State private var isEditing = false // Whether the user is in editing mode
    
    @Environment(\.presentationMode) var presentationMode // For cancel functionality
    
    var body: some View {
        VStack {
            // Input for the new schedule's name
            TextField("Schedule Name", text: $newScheduleName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Form to add/edit periods, limit to 9 periods (0-8)
            if newPeriods.count < 9 || isEditing {
                VStack {
                    TextField("Class ID", text: $classID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    // DatePicker for start time
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                        .padding()
                    
                    // DatePicker for end time
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                        .padding()
                    
                    Button(action: {
                        if let selectedIndex = selectedPeriodIndex {
                            updatePeriod(at: selectedIndex)
                        } else {
                            addPeriod()
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
            } else {
                Text("Maximum number of periods (9) reached.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            // List of added periods
            List {
                ForEach(newPeriods.indices, id: \.self) { index in
                    HStack {
                        Text("Period \(index): \(newPeriods[index].0)") // ClassID
                        Spacer()
                        Text("\(formattedTime(newPeriods[index].1)) - \(formattedTime(newPeriods[index].2))") // StartTime - EndTime
                    }
                    .onTapGesture {
                        editPeriod(at: index)
                    }
                }
                .onDelete(perform: deletePeriod) // Enable swipe to delete
            }
            
            Spacer()
            
            // Buttons to save or cancel the new schedule
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Cancel and go back
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Spacer()

                Button(action: {
                    saveNewSchedule()
                }) {
                    Text("Save Schedule")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Add New Schedule")
    }
    
    // Add a new period to the list
    func addPeriod() {
        // Check for duplicate time
        if isDuplicateTime() {
            print("Cannot add period with duplicate time!")
        } else {
            let newPeriod = (classID, startTime, endTime)
            newPeriods.append(newPeriod)
            
            // Clear input fields
            clearInputFields()
        }
    }
    
    // Update an existing period
    func updatePeriod(at index: Int) {
        // Prevent duplicate time when editing
        if isDuplicateTime(excludeIndex: index) {
            print("Cannot update period to a duplicate time!")
        } else {
            newPeriods[index] = (classID, startTime, endTime)
            clearInputFields()
            selectedPeriodIndex = nil
            isEditing = false
        }
    }
    
    // Edit an existing period
    func editPeriod(at index: Int) {
        let period = newPeriods[index]
        classID = period.0
        startTime = period.1
        endTime = period.2
        selectedPeriodIndex = index
        isEditing = true
    }
    
    // Delete a period
    func deletePeriod(at offsets: IndexSet) {
        newPeriods.remove(atOffsets: offsets)
        // Reset if editing the deleted period
        if let selectedIndex = selectedPeriodIndex, offsets.contains(selectedIndex) {
            clearInputFields()
            selectedPeriodIndex = nil
            isEditing = false
        }
    }
    
    // Save the new schedule to Firestore
    func saveNewSchedule() {
        let db = Firestore.firestore()
        let periodData = newPeriods.map { ["classID": $0.0, "startTime": formattedTime($0.1), "endTime": formattedTime($0.2)] }
        
        db.collection("schedules").document(newScheduleName).setData(["periods": periodData]) { error in
            if let error = error {
                print("Error saving schedule: \(error)")
            } else {
                print("New schedule saved successfully!")
                presentationMode.wrappedValue.dismiss() // Return to previous view after saving
            }
        }
    }
    
    // Check if the period has duplicate times
    func isDuplicateTime(excludeIndex: Int? = nil) -> Bool {
        for (index, period) in newPeriods.enumerated() {
            if index != excludeIndex && period.1 == startTime && period.2 == endTime {
                return true
            }
        }
        return false
    }
    
    // Clear input fields
    func clearInputFields() {
        classID = ""
        startTime = Date()
        endTime = Date()
        isEditing = false
    }
    
    // Format Date to String
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

struct TeacherAddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherAddScheduleView()
    }
}
