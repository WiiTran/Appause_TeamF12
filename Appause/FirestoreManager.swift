import Foundation
import FirebaseFirestore
import Combine

class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var enrolledClass: [(StudentClass, ClassTeacher?)] = []
    
    func fetchEnrolledClass(for studentEmail: String) {
        print("Fetching enrolled classes for studentEmail: \(studentEmail)")
        
        // Clear previous data
        self.enrolledClass = []
        
        // Query the `registration` collection by studentEmail
        db.collection("registration")
            .whereField("studentEmail", isEqualTo: studentEmail)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching registration data: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("No classes found for student with email \(studentEmail) in registration.")
                    return
                }
                
                print("Documents found in registration for \(studentEmail): \(documents.count)")
                
                let dispatchGroup = DispatchGroup()
                for document in documents {
                    let data = document.data()
                    let classID = data["classID"] as? String ?? ""
                    print("Found classID: \(classID)")
                    
                    dispatchGroup.enter()
                    
                    // Fetch class details based on classID
                    self.fetchClassDetails(classID: classID) { studentClass in
                        if let studentClass = studentClass {
                            dispatchGroup.enter()
                            
                            // Fetch teacher details
                            self.fetchTeacher(for: studentClass.teacherID) { teacher in
                                print("Appending class and teacher to enrolledClass array")
                                self.enrolledClass.append((studentClass, teacher))
                                dispatchGroup.leave()
                            }
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    print("Finished fetching all classes and teacher data for \(studentEmail).")
                    print("Total enrolled classes found: \(self.enrolledClass.count)")
                }
            }
    }
    
    // Helper function to fetch class details by classID
    private func fetchClassDetails(classID: String, completion: @escaping (StudentClass?) -> Void) {
        db.collection("classes").document(classID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching class details: \(error)")
                completion(nil)
                return
            }
            
            guard let data = document?.data() else {
                print("No class details found for classID \(classID).")
                completion(nil)
                return
            }
            
            // Create a StudentClass instance from the class data
            let className = data["className"] as? String ?? ""
            let teacherID = data["teacherID"] as? String ?? ""
            let teacherName = data["teacherName"] as? String ?? "Unknown"
            let classTime = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
            let days = data["days"] as? [String] ?? []
            
            let studentClassInstance = StudentClass(
                classID: classID,
                className: className,
                teacherID: teacherID,
                Name: teacherName,
                classTime: classTime,
                days: days
            )
            completion(studentClassInstance)
        }
    }
    
    // Helper function to fetch teacher details by teacherID
    private func fetchTeacher(for teacherID: String, completion: @escaping (ClassTeacher?) -> Void) {
        db.collection("teachers").document(teacherID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching teacher: \(error)")
                completion(nil)
                return
            }
            
            guard let data = document?.data() else {
                completion(nil)
                return
            }
            
            let teacher = ClassTeacher(Name: data["Name"] as? String ?? "Unknown", teacherID: teacherID)
            completion(teacher)
        }
    }
}

// Define the models for `StudentClass` and `ClassTeacher`
struct StudentClass {
    var classID: String
    var className: String
    var teacherID: String
    var Name: String
    var classTime: Date
    var days: [String]
}

struct ClassTeacher {
    var Name: String
    var teacherID: String
}

