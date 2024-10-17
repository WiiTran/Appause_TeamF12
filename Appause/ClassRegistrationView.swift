//
//  ClassRegistrationView.swift
//  Appause
//
//  Created by Abdurraziq on 10/13/24.
//
import SwiftUI
import FirebaseFirestore

struct ClassRegistrationView: View {
    @State private var selectedSubject: String = ""
    @State private var availableClasses: [ClassInfo] = [] // Array to hold fetched class details
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var studentID: String = "" // Student ID for registration
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = "" // Email for registration
    @State private var selectedClass: ClassInfo? = nil // Selected class for registration
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Search Classes")) {
                        Picker("Subject", selection: $selectedSubject) {
                            Text("Math").tag("Math")
                            Text("Social Studies").tag("Social Studies")
                            Text("Science").tag("Science")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: selectedSubject, perform: { _ in
                            fetchAvailableClasses() // Fetch classes when the subject changes
                        })
                        
                        if !availableClasses.isEmpty {
                            Section(header: Text("Available Classes")) {
                                ForEach(availableClasses) { classInfo in
                                    VStack(alignment: .leading) {
                                        Text("Teacher: \(classInfo.teacherName)")
                                        Text("Class ID: \(classInfo.classID)")
                                        Text("Time: \(classInfo.time)")
                                        Text("Room: \(classInfo.roomNumber)")
                                        Button("Select") {
                                            selectedClass = classInfo
                                            alertMessage = "You selected \(classInfo.teacherName)'s class at \(classInfo.time)."
                                            showAlert = true
                                        }
                                        .padding(.top, 5)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Student Information")) {
                        TextField("Enter Student ID", text: $studentID)
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                    }
                    
                    // Register button
                    Button("Register") {
                        registerForClass()
                    }
                    .disabled(!isRegisterButtonEnabled) // Enable button only if registration requirements are met
                    .padding()
                }
                .navigationTitle("Class Registration")
                
                if isLoading {
                    ProgressView("Loading...")
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Function to check if the Register button should be enabled
    var isRegisterButtonEnabled: Bool {
        return selectedClass != nil && !email.isEmpty
    }
    
    // Function to fetch available classes for the selected subject
    func fetchAvailableClasses() {
        guard !selectedSubject.isEmpty else { return }
        isLoading = true
        availableClasses.removeAll()
        
        let db = Firestore.firestore()
        db.collection("Classes")
            .whereField("subject", isEqualTo: selectedSubject)
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
                }
                
                if availableClasses.isEmpty {
                    alertMessage = "No classes found for the selected subject."
                    showAlert = true
                }
            }
    }
    
    func registerForClass() {
        guard let classInfo = selectedClass else {
            alertMessage = "Please select a class to register."
            showAlert = true
            return
        }
        
        let db = Firestore.firestore()
        let registrationData: [String: Any] = [
            "studentID": studentID,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "classID": classInfo.classID,
            "teacherName": classInfo.teacherName,
            "time": classInfo.time,
            "roomNumber": classInfo.roomNumber
        ]
        
        db.collection("registrations").document(studentID).setData(registrationData) { error in
            if let error = error {
                alertMessage = "Error registering for class: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "Successfully registered for \(classInfo.teacherName)'s class at \(classInfo.time)"
                showAlert = true
            }
        }
    }
}

struct ClassInfo: Identifiable {
    var id = UUID() // To conform to Identifiable
    var teacherName: String
    var classID: String
    var time: String
    var roomNumber: String
}

struct ClassRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassRegistrationView()
    }
}
