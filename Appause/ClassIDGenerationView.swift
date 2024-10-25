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
            TextField("Enter Class Name", text: $className)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
            
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
            
            // Dropdown for Days of the Week Selection
            VStack(alignment: .leading) {
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
            }
            
            // Pop-up with multi-select for days of the week
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
            TextField("Enter Teacher ID", text: $teacherID)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // Generate Class ID Button
            Button(action: {
                if className.isEmpty || teacherID.isEmpty || selectedDays.isEmpty {
                    alertMessage = "Please enter Class Name, Teacher ID, and select at least one day."
                    showAlert = true
                } else {
                    generateClassID()
                }
            }) {
                Text(isGenerating ? "Generating..." : "Create Class")
                    .padding()
                    .foregroundColor(.white)
                    .background(isGenerating ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(isGenerating)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
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
    
    // Toggle day selection when the button is tapped
    private func toggleDaySelection(_ day: String) {
        if let index = selectedDays.firstIndex(of: day) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(day)
        }
    }
    
    // Backend Logic to Generate Unique Class ID
    private func generateClassID() {
        isGenerating = true
        
        // Generate a random Class ID
        let newClassID = UUID().uuidString.prefix(8).uppercased()
        
        // Check if Class ID already exists in Firestore
        db.collection("classes").whereField("classID", isEqualTo: newClassID).getDocuments { (querySnapshot, error) in
            if let error = error {
                self.alertMessage = "Error checking existing classes: \(error.localizedDescription)"
                self.showAlert = true
                self.isGenerating = false
                return
            }
            
            if querySnapshot?.documents.isEmpty == true {
                // Save the new class
                self.saveClassToFirestore(classID: String(newClassID))
            } else {
                self.generateClassID()
            }
        }
    }
    
    // Save New Class to Firestore
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
            self.isGenerating = false
            if let error = error {
                self.alertMessage = "Error saving class: \(error.localizedDescription)"
                self.showAlert = true
            } else {
                self.generatedClassID = classID
            }
        }
    }
    
    // Helper function to format time
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
