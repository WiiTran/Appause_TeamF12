import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// Model for Class List
struct ClassModel: Identifiable {
    var id: String
    var enrolledClasses: [String] // Array of class names
}

// Model to represent individual class data
struct StudentClassModel: Identifiable {
    var id = UUID()
    var teacherID: String
    var classID: String
    var className: String
    var period: Int?
    var startTime: String
    var endTime: String
}


struct ClassListView: View {
    @State private var classes: [ClassModel] = []
    @State private var classesInfo: [StudentClassModel] = []
    @State private var isLoading = true
    @State private var userID: String?
    @State private var errorMessage: String?
    private let db = Firestore.firestore()

    
    var body: some View {
        VStack {
            
            
            Text("My Classes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            if let userID = userID {
                Text("Student ID: \(userID)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if classes.isEmpty {
                Text("No classes available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(classesInfo.sorted { ($0.period ?? Int.max) < ($1.period ?? Int.max) }) { classItem in
                    VStack(alignment: .leading, spacing: 10) {
                        // Display "Current Class" label if this is the current class
                        if isCurrentClass(classItem: classItem) {
                            Text("Current Class")
                            .font(.title2)
                            .foregroundColor(.green)
                            .padding(.bottom, 4)
                        }
                        
                        Text("Class ID: \(classItem.classID)")
                            .font(.headline)
                        Text("Class Name: \(classItem.className)")
                        if let period = classItem.period {
                            Text("Period: \(period)")
                        }
                        //                       s")
                        Text("Time: \(classItem.startTime) - \(classItem.endTime)")
                    }
                    .padding()
                    // .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .stroke(isCurrentClass(classItem: classItem) ? Color.green : Color.clear, lineWidth: 2)
                    )
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, -10)
            }
        }
        .onAppear {
            fetchUserId { userID in
                if let userID = userID {
                    self.userID = userID
                    fetchClassesList(userID: userID) { classes in
                        self.classes = classes
                        print(classes)// Store the classes locally
                        fetchClassInfo(classes) // Fetch details for the fetched classes
                    }
                } else {
                    self.errorMessage = "User not logged in"
                    self.isLoading = false
                }
            }
        }
        .padding()
    }
    
    // Fetch user ID from Firebase Authentication
    func fetchUserId(completion: @escaping (String?) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            print("User not logged in")
            completion(nil)
            return
        }

        db.collection("Users").whereField("Email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let document = querySnapshot?.documents.first, document.exists,
               let studentID = document.data()["StudentId"] as? String {
                print("Found user with StudentId: \(studentID)")
                completion(studentID)
            } else {
                print("No matching document found or StudentId not found")
                completion(nil)
            }
        }
    }

    // Fetch the classes the user is enrolled in based on user ID
    func fetchClassesList(userID: String, completion: @escaping ([ClassModel]) -> Void) {
        db.collection("Users").whereField("StudentId", isEqualTo: userID).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                self.errorMessage = "Error fetching classes"
                self.isLoading = false
                completion([])
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No classes found")
                self.errorMessage = "No classes found"
                self.isLoading = false
                completion([])
                return
            }

            // Assuming there is only one document per user (student)
            if let document = documents.first, let enrolledClasses = document.data()["enrolledClasses"] as? [String] {
                self.classes = [ClassModel(id: document.documentID, enrolledClasses: enrolledClasses)]
                completion(classes)
            } else {
                print("No enrolled classes found in the document")
                self.errorMessage = "No enrolled classes found"
                completion([])
            }
            self.isLoading = false
        }
    }
    
    func fetchClassInfo(_ classes: [ClassModel]) {
        for classItem in classes {
            for enrolledClass in classItem.enrolledClasses {
                print("Querying for classID \(enrolledClass)")
                db.collection("classes").whereField("classID", isEqualTo: enrolledClass).getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error.localizedDescription)")
                        self.errorMessage = "Error fetching classes"
                        self.isLoading = false
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents, !documents.isEmpty, documents.count == 1 else {
                        print("no documentssss")
                        return
                    }
                    
                    for document in documents {
                        let data = document.data()
                        
                        let teacherID = data["teacherID"] as? String ?? "unavailable"
                        let classID = data["classID"] as? String ?? "unavailable"
                        let className = data["className"] as? String ?? "unavailable"
                        let period = data["period"] as? Int
                        let startTime = data["startTime"] as? String ?? "unavailable"
                        let endTime = data["endTime"] as? String ?? "unavailable"
                        
                        let classInfo = StudentClassModel(
                            teacherID: teacherID,
                            classID: classID,
                            className: className,
                            period: period,
                            startTime: startTime,
                            endTime: endTime)
                        
                        self.classesInfo.append(classInfo)
                        print(self.classesInfo)
                        print("Query Successful")
                    }
                }
            }
        }
    }
    
    // Function to check if a class is currently in session
    private func isCurrentClass(classItem: StudentClassModel) -> Bool {
        let currentDate = Date()
        
        // Formatter to interpret the AM/PM format in startTime and endTime from the database
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "h:mm a"
        
        // Formatter for converting times to 24-hour format for comparison
        let comparisonFormatter = DateFormatter()
        comparisonFormatter.dateFormat = "HH:mm"
        
        guard
            let startTimeDate = inputFormatter.date(from: classItem.startTime),
            let endTimeDate = inputFormatter.date(from: classItem.endTime)
        else {
            return false
        }
        
        let startTimeString = comparisonFormatter.string(from: startTimeDate)
        let endTimeString = comparisonFormatter.string(from: endTimeDate)
        
        let currentTimeString = comparisonFormatter.string(from: currentDate)
        
        guard
            let startTime = comparisonFormatter.date(from: startTimeString),
            let endTime = comparisonFormatter.date(from: endTimeString),
            let currentTime = comparisonFormatter.date(from: currentTimeString)
        else {
            return false
        }
        
        return currentTime >= startTime && currentTime <= endTime
    }
    
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassListView()
    }
}
