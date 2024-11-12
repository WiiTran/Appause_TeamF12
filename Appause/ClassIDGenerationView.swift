//
//  ClassIDGenerationView.swift
//  Appause
//
//  Created by Dash on 10/08/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ClassIDGenerationView: View {
    @State private var className = ""
    @State private var classStartTime = Date()
    @State private var classEndTime = Date()
    @State private var selectedDays: [String] = []
    @State private var teacherID: String?
    //@State private var period: String = ""
    @State private var period = 1
    @State private var generatedClassID: String? = nil
    @State private var isGenerating = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isDaysSelectionVisible = false
    
    @State private var classNameError = false
    @State private var teacherIDError = false
    @State private var daysError = false
    @State private var overlapError = false
    
    private let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    private let db = Firestore.firestore()
    
    func fetchTeacherID() {
        fetchTeacherID { teacherID, error in
            if let error = error {
                print("Failed to fetch TeacherID: \(error)")
            } else if let teacherID = teacherID {
                self.teacherID = teacherID
                print(teacherID)
            }
        }
    }
    
    @EnvironmentObject var scheduleState: ScheduleState
    @State private var currentSchedule = "Regular"

    var body: some View {
        ScrollView {  // Added ScrollView to prevent content overflow
            VStack(spacing: 16) {
                Text("Create a New Class")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 5) {
                    TextField("Enter Class Name", text: $className)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    if classNameError {
                        Text("Class Name is required")
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                }

                DatePicker("Select Start Time", selection: $classStartTime, displayedComponents: .hourAndMinute)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                DatePicker("Select End Time", selection: $classEndTime, displayedComponents: .hourAndMinute)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Enter Period")
                        .font(.headline)
                        .padding(.leading)
                    
                    Picker("Period", selection: $period) {
                        ForEach(1...8, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)

//                    TextField("Enter Period (e.g., 1, 2, 3)", text: $period)
//                        .keyboardType(.numberPad)
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                        .padding(.horizontal)
                }

//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Select Days of the Week")
//                        .font(.headline)
//                        .padding(.leading)
//
//                    Button(action: { isDaysSelectionVisible.toggle() }) {
//                        HStack {
//                            Text(selectedDays.isEmpty ? "Choose Days" : selectedDays.joined(separator: ", "))
//                                .foregroundColor(selectedDays.isEmpty ? .gray : .blue)
//                                .padding(.leading)
//
//                            Spacer()
//
//                            Image(systemName: "chevron.down")
//                                .rotationEffect(.degrees(isDaysSelectionVisible ? 180 : 0))
//                                .padding(.trailing)
//                        }
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                        .padding(.horizontal)
//                    }
//
//                    if daysError {
//                        Text("Please select at least one day")
//                            .foregroundColor(.red)
//                            .padding(.leading)
//                    }
//                }
//
//                if isDaysSelectionVisible {
//                    VStack {
//                        ForEach(daysOfWeek, id: \.self) { day in
//                            HStack {
//                                Text(day)
//                                Spacer()
//                                Button(action: { toggleDaySelection(day) }) {
//                                    Image(systemName: selectedDays.contains(day) ? "checkmark.square" : "square")
//                                        .foregroundColor(selectedDays.contains(day) ? .blue : .gray)
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
//                    .background(Color.white)
//                    .cornerRadius(8)
//                    .shadow(radius: 10)
//                    .padding(.horizontal)
//                }
//
//                VStack(alignment: .leading, spacing: 5) {
//                    TextField("Enter Teacher ID", text: $teacherID)
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                        .padding(.horizontal)
//
//                    if teacherIDError {
//                        Text("Teacher ID is required")
//                            .foregroundColor(.red)
//                            .padding(.leading)
//                    }
//                }

                if overlapError {
                    Text("Time conflict detected with an existing class.")
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: validateAndGenerateClassID) {
                    Text(isGenerating ? "Generating..." : "Create Class")
                        .padding()
                        .foregroundColor(.white)
                        .background(isGenerating ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(isGenerating)

                if let classID = generatedClassID {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Class Created Successfully!")
                            .font(.headline)
                            .padding(.top, 20)

                        Text("Class Name: \(className)")
//                        Text("Class Days: \(selectedDays.joined(separator: ", "))")
                        Text("Class Period: \(formattedTime(classStartTime)) - \(formattedTime(classEndTime))")
                        Text("Teacher ID: \(teacherID)")
                        Text("Period: \(period)")
                        Text("Generated Class ID: \(classID)")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(.top, 20)
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear() {
            fetchTeacherID()
            currentSchedule = scheduleState.currentSchedule
            print(currentSchedule)
        }
    }

//    private func toggleDaySelection(_ day: String) {
//        if let index = selectedDays.firstIndex(of: day) {
//            selectedDays.remove(at: index)
//        } else {
//            selectedDays.append(day)
//        }
//    }

    private func validateAndGenerateClassID() {
        classNameError = className.isEmpty
        teacherIDError = (teacherID?.isEmpty == true)
//        daysError = selectedDays.isEmpty

        if !classNameError && !teacherIDError {
            checkForOverlappingClass(teacherID: teacherID!) { hasOverlap, error in
                if let error = error {
                    print("Error checking for overlapping classes: \(error)")
                } else if hasOverlap {
                    print("Duplicate period found for this teacher")
                    print(period)
                }else {
                    print("no overlap")
                    generateClassID()
                }
            }
        } else {
            print("error", classNameError, " ", teacherIDError)
        }
            
    }
    
    private func checkForOverlappingClass(teacherID: String, completion: @escaping (Bool, Error?) -> Void) {
        isGenerating = true
        
        db.collection("classes").whereField("teacherID", isEqualTo: teacherID).getDocuments { (querySnapshot, error) in
            defer{ isGenerating = false }
            
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(false, nil)
                return
            }
            
            var periodSet = Set<Int>()
            for document in documents {
                if let period = document.data()["period"] as? Int {
                    if periodSet.contains(period){
                        completion(true, nil)
                        return
                    } else {
                        periodSet.insert(period)
                    }
                }
            }
            
            if periodSet.contains(self.period) {
                completion(true, nil)
            } else {
                periodSet.insert(self.period)
                completion(false, nil)
            }
        }
    }
    

//    private func checkForOverlappingClass() {
//        isGenerating = true
//
//        db.collection("classes")
//            .whereField("teacherID", isEqualTo: teacherID)
////            .whereField("days", arrayContainsAny: selectedDays)
//            .getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    alertMessage = "Error fetching classes: \(error.localizedDescription)"
//                    showAlert = true
//                    isGenerating = false
//                    return
//                }
//
//                let conflictExists = querySnapshot?.documents.contains { document in
//                    let existingStartTime = document["startTime"] as? String ?? ""
//                    let existingEndTime = document["endTime"] as? String ?? ""
//
//                    return self.timesOverlap(existingStartTime: existingStartTime, existingEndTime: existingEndTime)
//                } ?? false
//
//                if conflictExists {
//                    overlapError = true
//                    isGenerating = false
//                } else {
//                    overlapError = false
//                    generateClassID()
//                }
//            }
//    }

//    private func timesOverlap(existingStartTime: String, existingEndTime: String) -> Bool {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//
//        guard let existingStart = formatter.date(from: existingStartTime),
//              let existingEnd = formatter.date(from: existingEndTime),
//              let newStart = formatter.date(from: formattedTime(classStartTime)),
//              let newEnd = formatter.date(from: formattedTime(classEndTime)) else {
//            return false
//        }
//
//        return (newStart < existingEnd) && (newEnd > existingStart)
//    }

    private func generateClassID() {
        let newClassID = UUID().uuidString.prefix(8).uppercased()
        
        checkIfClassIDExists(classID: String(newClassID)) { exists in
            if exists {
                generateClassID()  // Retry with a new ID if the ID exists
            } else {
                saveClassToFirestore(classID: String(newClassID)) 
                // Save if ID is unique
                print("woo")
            }
        }
    }

    private func checkIfClassIDExists(classID: String, completion: @escaping (Bool) -> Void) {
        db.collection("classes")
            .whereField("classID", isEqualTo: classID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error checking Class ID: \(error.localizedDescription)")
                    completion(true)  // Assume ID exists to prevent using it
                    return
                }

                if let documents = querySnapshot?.documents, !documents.isEmpty {
                    completion(true)  // ID exists
                } else {
                    completion(false)  // ID is unique
                }
            }
    }

    private func saveClassToFirestore(classID: String) {
        let classData: [String: Any] = [
            "classID": classID,
            "className": className,
//            "days": selectedDays,
            "startTime": formattedTime(classStartTime),
            "endTime": formattedTime(classEndTime),
            "teacherID": teacherID,
            "period": period
        ]

        db.collection("classes").addDocument(data: classData) { error in
            isGenerating = false
            if let error = error {
                alertMessage = "Error saving class: \(error.localizedDescription)"
                showAlert = true
            } else {
                generatedClassID = classID
                updateTeacherClasses(classID: classID)  // Add class ID to teacher's record
            }
        }
    }

    private func updateTeacherClasses(classID: String) {
        db.collection("Teachers")
            .whereField("teacherID", isEqualTo: teacherID)  // Query the teacher document by the teacherID field
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error finding teacher: \(error.localizedDescription)")
                    return
                }

                guard let document = querySnapshot?.documents.first else {
                    print("No teacher found with the provided teacherID.")
                    return
                }

                let teacherRef = document.reference
                teacherRef.updateData([
                    "classesTaught": FieldValue.arrayUnion([classID])
                ]) { updateError in
                    if let updateError = updateError {
                        print("Error updating teacher's classes: \(updateError.localizedDescription)")
                    }
                print("success")
                }
            }
    }

    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
    
    private func fetchTeacherID(completion: @escaping (String?, String?) -> Void){
        
        guard let userID = Auth.auth().currentUser?.email else {
            print("User not logged in")
            completion(nil, "User not logged in")
            return
        }
       
        print(userID)
        
        db.collection("Teachers").whereField("Email", isEqualTo: userID).getDocuments() { querySnapshot, error in
            if let error = error {
                completion(nil, "Error fetching document: \(error.localizedDescription)")
            } else if let document = querySnapshot?.documents.first, document.exists {
                if let teacherID = document.data()["teacherID"] as? String {
                    completion(teacherID, nil)
                    return
                } else {
                    print("TeacherID not found.")
                    completion(nil, "TeacherID not found")
                    return
                }
            } else {
                print("Document does not exist.")
                completion(nil, "Document does not exist")
                return
            }
        }
    }
}

struct ClassIDGenerationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassIDGenerationView()
    }
}
