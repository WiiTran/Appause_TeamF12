//
//  ClassIDGenerationView.swift
//  Appause
//
//  Created by Dash on 10/08/24.
//

import SwiftUI
import FirebaseFirestore

struct ClassIDGenerationView: View {
    @State private var className = ""
    @State private var classStartTime = Date()
    @State private var classEndTime = Date()
    @State private var selectedDays: [String] = []
    @State private var teacherID = ""
    @State private var generatedClassID: String? = nil
    @State private var isGenerating = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isDaysSelectionVisible = false

    // Validation state for error messages
    @State private var classNameError = false
    @State private var teacherIDError = false
    @State private var daysError = false

    private let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 75)
            
            Text("Create a New Class")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            
            // Class Name Input
            VStack(alignment: .leading, spacing: 5) {
                TextField("Enter Class Name", text: $className)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                // Display error message if classNameError is true
                if classNameError {
                    Text("Class Name is required")
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }
            
            // Class Start Time Picker
            DatePicker("Select Start Time", selection: $classStartTime, displayedComponents: .hourAndMinute)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // Class End Time Picker
            DatePicker("Select End Time", selection: $classEndTime, displayedComponents: .hourAndMinute)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // Days of the Week Selection
            VStack(alignment: .leading, spacing: 5) {
                Text("Select Days of the Week")
                    .font(.headline)
                    .padding(.leading)
                
                Button(action: {
                    isDaysSelectionVisible.toggle()
                }) {
                    HStack {
                        Text(selectedDays.isEmpty ? "Choose Days" : selectedDays.joined(separator: ", "))
                            .foregroundColor(selectedDays.isEmpty ? .gray : .blue)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isDaysSelectionVisible ? 180 : 0))
                            .padding(.trailing)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                // Display error message if daysError is true
                if daysError {
                    Text("Please select at least one day")
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }

            // Days of the Week Pop-up
            if isDaysSelectionVisible {
                VStack {
                    ForEach(daysOfWeek, id: \.self) { day in
                        HStack {
                            Text(day)
                            Spacer()
                            Button(action: {
                                toggleDaySelection(day)
                            }) {
                                Image(systemName: selectedDays.contains(day) ? "checkmark.square" : "square")
                                    .foregroundColor(selectedDays.contains(day) ? .blue : .gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 10)
                .padding(.horizontal)
            }
            
            // Teacher ID Input
            VStack(alignment: .leading, spacing: 5) {
                TextField("Enter Teacher ID", text: $teacherID)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                // Display error message if teacherIDError is true
                if teacherIDError {
                    Text("Teacher ID is required")
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }
            
            // Generate Class ID Button
            Button(action: validateAndGenerateClassID) {
                Text(isGenerating ? "Generating..." : "Create Class")
                    .padding()
                    .foregroundColor(.white)
                    .background(isGenerating ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(isGenerating)

            // Display Generated Class Information
            if let classID = generatedClassID {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Class Created Successfully!")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    Text("Class Name: \(className)")
                    Text("Class Days: \(selectedDays.joined(separator: ", "))")
                    Text("Class Period: \(formattedTime(classStartTime)) - \(formattedTime(classEndTime))")
                    Text("Teacher ID: \(teacherID)")
                    Text("Generated Class ID: \(classID)")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // Toggle day selection
    private func toggleDaySelection(_ day: String) {
        if let index = selectedDays.firstIndex(of: day) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(day)
        }
    }

    // Validate fields and generate class ID
    private func validateAndGenerateClassID() {
        // Reset error states
        classNameError = className.isEmpty
        teacherIDError = teacherID.isEmpty
        daysError = selectedDays.isEmpty

        // Check if all fields are valid
        if !classNameError && !teacherIDError && !daysError {
            generateClassID()
        }
    }

    // Generate a unique class ID
    private func generateClassID() {
        isGenerating = true
        let newClassID = UUID().uuidString.prefix(8).uppercased()
        
        db.collection("classes").whereField("classID", isEqualTo: newClassID).getDocuments { (querySnapshot, error) in
            if let error = error {
                alertMessage = "Error checking existing classes: \(error.localizedDescription)"
                showAlert = true
                isGenerating = false
                return
            }
            
            if querySnapshot?.documents.isEmpty == true {
                saveClassToFirestore(classID: String(newClassID))
            } else {
                generateClassID()
            }
        }
    }

    // Save class to Firestore
    private func saveClassToFirestore(classID: String) {
        let classData: [String: Any] = [
            "classID": classID,
            "className": className,
            "days": selectedDays,
            "startTime": formattedTime(classStartTime),
            "endTime": formattedTime(classEndTime),
            "teacherID": teacherID
        ]
        
        db.collection("classes").addDocument(data: classData) { error in
            isGenerating = false
            if let error = error {
                alertMessage = "Error saving class: \(error.localizedDescription)"
                showAlert = true
            } else {
                generatedClassID = classID
            }
        }
    }

    // Format time
    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: time)
    }
}

struct ClassIDGenerationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassIDGenerationView()
    }
}
