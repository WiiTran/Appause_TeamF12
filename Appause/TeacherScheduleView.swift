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
import Combine
import FirebaseFirestore
import FirebaseAuth

final class ScheduleState: ObservableObject{
    static let scheduleState = ScheduleState()
    @Published var currentSchedule: String = "Regular"
    init() {}
    
    func setCurrentSchedule( scheduleType : String) {
        currentSchedule = scheduleType
    }
    
    func getCurrentSchedule() -> String {
        return currentSchedule
    }
}

struct TeacherScheduleView: View {
    @State private var scheduleName = "Regular" // Default selected schedule name
    @State private var schedules: [String] = ["Regular", "Thursday", "Minimum Day", "Rally", "Finals"] // List of available schedules
    @State private var periods: [SchedulePeriod] = [] // List of periods for the selected schedule
    @State private var editingMode = false // Indicates if the user is editing the schedule
    @State private var newClassID = "" // Name of the class for adding/editing periods
    @State private var newStartTime = Date() // Start time for adding/editing periods
    @State private var newEndTime = Date() // End time for adding/editing periods
    @State private var selectedPeriodIndex: Int? // Selected period index for editing
    private let db = Firestore.firestore()
    @State private var classes: [String] = []
        
    var body: some View {
        NavigationView {
            VStack {
                Text("Teacher Schedule")
                    .font(.system(size: 32))
                    .bold()
                    .padding(.top)
                
                // Display selected schedule name
                Text(scheduleName)
                    .font(.title)
                    .padding(.bottom)

                // Dropdown menu to select a schedule
                Picker("Select Schedule", selection: $scheduleName) {
                    ForEach(schedules, id: \.self) { schedule in
                        Text(schedule)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.bottom)
                .onChange(of: scheduleName) { newSchedule in
                    loadSchedule(newSchedule)
                    ScheduleState.scheduleState.setCurrentSchedule(scheduleType: scheduleName)
                    //change current class times
                    print(ScheduleState.scheduleState.getCurrentSchedule())
                    updateClassTimes()
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
            .onAppear {
                scheduleName = ScheduleState.scheduleState.getCurrentSchedule()
                loadSchedule(scheduleName) // Load the initial schedule when the view appears
                updateClassTimes()
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
    
    private func fetchTeacherClasses(completion: @escaping ([String]?, String?) -> Void){
        
        guard let userID = Auth.auth().currentUser?.email else {
            print("User not logged in")
            completion(nil, "User not logged in")
            return
        }
        
        db.collection("Teachers").whereField("Email", isEqualTo: userID).getDocuments() { querySnapshot, error in
            
            if let error = error {
                completion(nil, "Error fetching document: \(error.localizedDescription)")
            } else if let document = querySnapshot?.documents.first, document.exists {
                if let classes = document.data()["classesTaught"] as? [String] {
                    completion(classes, nil)
                    return
                } else {
                    print("TeacherID not found.")
                    completion(nil, "classes not found")
                    return
                }
            } else {
                print("Document does not exist.")
                completion(nil, "Document does not exist")
                return
            }
        }
    }
    
    private func setClassTimes(_ scheduleType: String, _ period: Int, _ timeNeeded: String) -> String{
        let schedule = ScheduleDatabaseManager.shared.loadPermanentSchedule(scheduleType)
        
        guard let schedule = schedule else {
            print("Schedule is nil")
            return "Scedule is nil"
        }
        
        let periodNeeded = "Period \(period - 1)"
        
        let fetchSchedule = schedule.first {schedulePeriod in schedulePeriod.name == periodNeeded}
        
        if timeNeeded == "start" {
            let classStartTime = fetchSchedule?.startTime ?? "unavailable"
            return classStartTime
        } else if timeNeeded == "end" {
            let classEndTime = fetchSchedule?.endTime ?? "unavailable"
            return classEndTime
        } else {
            return "Incorrect parameter used to fetch end/start time."
        }
    }
    
    private func fetchClassPeriod(_ docRef: DocumentReference, completion: @escaping (Int?, Error?) -> Void) {
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            // Check if the document exists and retrieve the field
            if let document = document, document.exists {
                if let period = document.get("period") as? Int {
                    completion(period, nil)
                } else {
                    print("Period does not exist or is not of the expected type.")
                    completion(nil, nil)
                }
            } else {
                print("Document does not exist.")
                completion(nil, nil)
            }
        }
    }
    
    private func updateClassTimes() {
        fetchTeacherClasses { classes, error in
            if let error = error {
                print("Failed to fetch classes: \(error)")
            }
            
            guard let classes = classes else {
                print("No classes found")
                return
            }
            
            print(classes)
                    
            for classID in classes {
                db.collection("classes").whereField("classID", isEqualTo: classID).getDocuments() { (querySnapshot, error) in
                    
                    if let error = error {
                        print("Error finding class: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let document = querySnapshot?.documents.first else {
                        print("No class found with the provided classID.")
                        return
                    }
                                        
                    let classRef = document.reference
                    fetchClassPeriod(classRef) { period, error in
                        if let error = error {
                            print("error fetching class period: \(error)")
                        } else if let period = period {
                            print("fetched period: \(period)")
                            
                            let startTime = setClassTimes(scheduleName, period, "start")
                            let endTime = setClassTimes(scheduleName, period, "end")
                            
                            classRef.updateData([
                                "startTime": startTime,
                                "endTime": endTime
                            ]) { updateError in
                                if let updateError = updateError {
                                    print("Error updating teacher's classes: \(updateError.localizedDescription)")
                                }
                            }
                        } else {
                            print("no period found in document")
                        }
                    }
                    print("success")
                }
            }
        }
    }
}

struct TeacherScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherScheduleView()
    }
}
