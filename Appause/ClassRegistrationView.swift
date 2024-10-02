//
//  ClassRegistrationView.swift
//  Appause
//
//  Created by Abdurraziq on 10/1/24.
//

import SwiftUI

struct ClassRegistrationView: View {
    @State private var classID: String = ""
    @State private var selectedClassTime: String = "12 PM" // Default selection
    
    let availableTimes = ["12 PM", "2 PM"] // Example times
    
    var body: some View {
        NavigationView { // Add NavigationView for better navigation structure
            Form {
                Section(header: Text("Class Details")) {
                    TextField("Enter Class ID", text: $classID) // Input for Class ID
                    
                    Picker("Select Class Time", selection: $selectedClassTime) {
                        ForEach(availableTimes, id: \.self) {
                            Text($0) // Display available class times
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Optional: change picker style for a segmented control
                }
                
                Section {
                    Button("Register for Class") {
                        registerForClass() // Button to trigger registration action
                    }
                }
            }
            .navigationTitle("Register for Class") // Navigation title for the view
        }
    }
    
    // Function to simulate class registration
    func registerForClass() {
        print("Class ID: \(classID)")
        print("Selected Class Time: \(selectedClassTime)")
        // Here you can add the logic to handle the registration
    }
}

struct ClassRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassRegistrationView()
    }
}

