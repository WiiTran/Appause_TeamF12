//
//   AddClassView.swift
//  Appause
//
//  Created by Abdurraziq on 10/14/24.
//

import SwiftUI
import FirebaseFirestore

struct AddClassView: View {
    @State private var subject: String = ""
    @State private var classID: String = ""
    @State private var teacherName: String = ""
    @State private var time: String = ""
    @State private var roomNumber: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Class Information")) {
                    TextField("Subject", text: $subject)
                    TextField("Class ID", text: $classID)
                    TextField("Teacher Name", text: $teacherName)
                    TextField("Time", text: $time)
                    TextField("Room Number", text: $roomNumber)
                }
                
                Button("Add Class") {
                    addClass()
                }
            }
            .navigationTitle("Add New Class")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addClass() {
        let db = Firestore.firestore()
        
        // Create a dictionary to represent the class data
        let classData: [String: Any] = [
            "subject": subject,
            "classID": classID,
            "teacherName": teacherName,
            "time": time,
            "roomNumber": roomNumber
        ]
        
        // Add the data to a Firestore collection called "classes"
        db.collection("Classes").addDocument(data: classData) { error in
            if let error = error {
                alertMessage = "Error adding class: \(error.localizedDescription)"
            } else {
                alertMessage = "Class successfully added."
            }
            showAlert = true
        }
    }
}

struct AddClassView_Previews: PreviewProvider {
    static var previews: some View {
        AddClassView()
    }
}
