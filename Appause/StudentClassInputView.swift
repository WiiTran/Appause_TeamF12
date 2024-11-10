import SwiftUI
import FirebaseFirestore

struct StudentClassInputView: View {
    @State private var classID: String = ""
    @State private var availableClasses: [ClassInfo] = [] // Array to hold the fetched class details
    @State private var selectedClass: ClassInfo? = nil // To hold the selected class
    @State private var studentEmail: String = "" // To hold student email for registration
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Section for entering Class ID and fetching class details
                    Section(header: Text("Enter Class ID")) {
                        TextField("Class ID", text: $classID)
                            .keyboardType(.numberPad)
                            .autocapitalization(.allCharacters) // Enforce uppercase to match Firestore data
                            .disableAutocorrection(true)
                        
                        Button("Fetch Class Details") {
                            fetchClassDetails()
                        }
                    }
                    
                    // Section to display available classes
                    if !availableClasses.isEmpty {
                        Section(header: Text("Available Classes")) {
                            ForEach(availableClasses) { classInfo in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Class Name: \(classInfo.className)")
                                        .font(.headline)
                                    Text("Start Time: \(classInfo.startTime)")
                                    Text("End Time: \(classInfo.endTime)")
                                    Text("Teacher ID: \(classInfo.teacherID)")
                                    Text("Days: \(classInfo.days.joined(separator: ", "))")
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                                .padding(.vertical, 5)
                            }
                        }
                    }

                    // Separate section for student email input and register button
                    if !availableClasses.isEmpty {
                        Section(header: Text("Register for Class")) {
                            TextField("Enter Student Email", text: $studentEmail)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            Button(action: {
                                if let classInfo = availableClasses.first {
                                    registerForClass(classInfo)
                                }
                            }) {
                                Text("Register for Class")
                                    .foregroundColor(.blue)
                            }
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
        
        print("Searching for classID: \(classID)") // Debugging line

        let db = Firestore.firestore()
        db.collection("classes")
            .whereField("classID", isEqualTo: classID)
            .getDocuments { (snapshot, error) in
                self.isLoading = false
                
                if let error = error {
                    self.alertMessage = "Error fetching classes: \(error.localizedDescription)"
                    self.showAlert = true
                    print("Firestore error: \(error.localizedDescription)") // Debugging line
                    return
                }
                
                if let documents = snapshot?.documents {
                    print("Documents found: \(documents.count)") // Debugging line
                    availableClasses = documents.compactMap { doc in
                        let data = doc.data()
                        print("Document data: \(data)") // Debugging line
                        return ClassInfo(
                            teacherID: data["teacherID"] as? String ?? "N/A",
                            classID: data["classID"] as? String ?? "N/A",
                            className: data["className"] as? String ?? "N/A",
                            startTime: data["startTime"] as? String ?? "N/A",
                            endTime: data["endTime"] as? String ?? "N/A",
                            days: (data["days"] as? [String]) ?? []
                        )
                    }
                    
                    if availableClasses.isEmpty {
                        alertMessage = "No classes found for the entered ID."
                        showAlert = true
                        print("No matching classes found for classID \(classID)") // Debugging line
                    }
                }
            }
    }
    
    func registerForClass(_ classInfo: ClassInfo) {
        guard !studentEmail.isEmpty else {
            alertMessage = "Please enter your Student Email."
            showAlert = true
            return
        }
        
        let db = Firestore.firestore()
        
        // Create a registration document with student and class details
        let registrationData: [String: Any] = [
            "classID": classInfo.classID,
            "className": classInfo.className,
            "teacherID": classInfo.teacherID,
            "startTime": classInfo.startTime,
            "endTime": classInfo.endTime,
            "days": classInfo.days,
            "studentEmail": studentEmail,
            "timestamp": Timestamp(date: Date()) // Adding a timestamp
        ]
        
        // Using student email as the document ID to store the registration in the "registrations" collection
        db.collection("registrations").document(studentEmail).setData(registrationData) { error in
            if let error = error {
                alertMessage = "Error registering for class: \(error.localizedDescription)"
                showAlert = true
                print("Registration error: \(error.localizedDescription)") // Debugging line
            } else {
                alertMessage = "Successfully registered for \(classInfo.className)!"
                showAlert = true
                print("Registered for class: \(classInfo.className) with studentEmail: \(studentEmail)") // Debugging line
            }
        }
    }
}

struct ClassInfo: Identifiable {
    var id = UUID() // To conform to Identifiable
    var teacherID: String
    var classID: String
    var className: String
    var startTime: String
    var endTime: String
    var days: [String] // Added 'days' as an array of strings
}

struct StudentClassInputView_Previews: PreviewProvider {
    static var previews: some View {
        StudentClassInputView()
    }
}

