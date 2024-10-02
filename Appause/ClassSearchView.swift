//
//  ClassSearchView.swift
//  Appause
//
//  Created by Abdurraziq on 10/1/24.
//

import SwiftUI
import Firebase

struct ClassSearchView: View {
    @State private var classID: String = ""
    @State private var selectedClassTime: String = "12 PM"
    @State private var errorMessage: String? = nil
    @State private var isClassValid: Bool = false
    @State private var isLoading: Bool = false
    
    let availableTimes = ["12 PM", "2 PM"] // Sample class times
    
    var body: some View {
        NavigationView {
            Form {
                // TextField for Class ID input
                TextField("Enter Class ID", text: $classID)
                
                // Picker for selecting Class Time
                Picker("Select Class Time", selection: $selectedClassTime) {
                    ForEach(availableTimes, id: \.self) {
                        Text($0)
                    }
                }
                
                // Button to search class in Firebase
                Button(action: searchClass) {
                    Text("Search Class")
                        .frame(maxWidth: .infinity)
                }
                
                // Display error or success message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                if isClassValid {
                    Text("Class is valid!")
                        .foregroundColor(.green)
                }
                
                if isLoading {
                    ProgressView("Searching...")
                }
            }
            .navigationTitle("Search for Class")
        }
    }
    
    // Function to search class in Firebase based on ID and time
    func searchClass() {
        guard !classID.isEmpty else {
            errorMessage = "Please enter a valid class ID."
            return
        }
        
        isLoading = true
        errorMessage = nil
        isClassValid = false
        
        // Assuming Firebase Realtime Database or Firestore setup
        let db = Firestore.firestore()
        let classRef = db.collection("classes").document(classID) // Assuming a 'classes' collection
        
        classRef.getDocument { (document, error) in
            isLoading = false
            
            if let error = error {
                errorMessage = "Error fetching class: \(error.localizedDescription)"
                return
            }
            
            guard let document = document, document.exists else {
                errorMessage = "Class ID not found."
                return
            }
            
            // Get class data from Firebase
            let classData = document.data()
            let availableTime = classData?["availableTime"] as? String
            let isExpired = classData?["isExpired"] as? Bool ?? false
            
            // Validate class time and expiration
            if isExpired {
                errorMessage = "This class ID is expired."
            } else if availableTime == selectedClassTime {
                isClassValid = true
            } else {
                errorMessage = "Invalid class time."
            }
        }
    }
}

