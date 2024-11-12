//StudentClassInputView.swift
//  Appause
//
//  Created by Abdurraziq on 10/14/24.
//

import SwiftUI
import FirebaseFirestore

struct StudentClassInputView: View {
    @State private var classID: String = ""
    @State private var availableClasses: [ClassInfo] = [] // Array to hold the fetched class details
    @State private var selectedClassTime: String? = nil // To hold the selected class time
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Enter Class ID")) {
                        TextField("Class ID", text: $classID)
                            .keyboardType(.numberPad)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        Button("Fetch Class Details") {
                            fetchClassDetails()
                        }
                    }

                    if !availableClasses.isEmpty {
                        Section(header: Text("Available Class Times")) {
                            Picker("Select Class Time", selection: $selectedClassTime) {
                                ForEach(availableClasses, id: \.classID) { classInfo in
                                    Text("\(classInfo.teacherName) - \(classInfo.time) (Room: \(classInfo.roomNumber))")
                                        .tag(classInfo.time)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                }
                .navigationTitle("Class Input")
                
                if isLoading {
                    ProgressView("Loading...")
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func fetchClassDetails() {
        isLoading = true
        availableClasses.removeAll() // Clear previous results
        
        let db = Firestore.firestore()
        db.collection("Classes")
            .whereField("classID", isEqualTo: classID)
            .getDocuments { (snapshot, error) in
                isLoading = false
                if let error = error {
                    alertMessage = "Error fetching classes: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                
                if let documents = snapshot?.documents {
                    availableClasses = documents.map { doc in
                        let data = doc.data()
                        return ClassInfo(
                            teacherName: data["teacherName"] as? String ?? "N/A",
                            classID: data["classID"] as? String ?? "N/A",
                            time: data["time"] as? String ?? "N/A",
                            roomNumber: data["roomNumber"] as? String ?? "N/A"
                        )
                    }
                    
                    if availableClasses.isEmpty {
                        alertMessage = "No classes found for the entered ID."
                        showAlert = true
                    }
                }
            }
    }
}

struct classInfo: Identifiable {
    var id = UUID() // To conform to Identifiable
    var teacherName: String
    var classID: String
    var time: String
    var roomNumber: String
}


struct StudentClassInputView_Previews: PreviewProvider {
    static var previews: some View {
        StudentClassInputView()
    }
}
