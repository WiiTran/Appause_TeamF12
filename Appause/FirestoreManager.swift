import Foundation
import FirebaseFirestore
import Combine

class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var enrolledClass: [(studentClass, Teacher?)] = []
    
    func fetchEnrolledClass(for StudentID: String) {
        print("Fetching enrolled classes for StudentID: \(StudentID)") // Debug print
        self.enrolledClass = []
        db.collection("classes")
            .whereField("StudentID", isEqualTo: StudentID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching classes: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No classes found.")
                    return
                }
                print("Documents fetched: \(documents.count)") // Debug print
                var classes: [studentClass] = []
                let dispatchGroup = DispatchGroup()
                
                for document in documents {
                    let data = document.data()
                    let classID = data["classID"] as? String ?? ""
                    let className = data["className"] as? String ?? ""
                    let teacherID = data["teacherID"] as? String ?? ""
                    let Name = data["Name"] as? String ??  "Unknown"
                    let classTime = (data["classTime"] as? Timestamp)?.dateValue() ?? Date()
                    let days = data["days"] as? [String] ?? []
                    
                    let studentClassInstance = studentClass(
                        classID: classID,
                        className: className,
                        teacherID: teacherID,
                        Name: Name,
                        classTime: classTime,
                        days: days
                        
                    )
                    classes.append(studentClassInstance)
                }
                
                for studentClass in classes {
                    dispatchGroup.enter()
                    self.fetchTeacher(for: studentClass.teacherID) { teacher in
                        self.enrolledClass.append((studentClass, teacher))
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    // This will update the published property
                    self.enrolledClass = classes.map { ($0, nil) } // Resetting in case of duplicates
                }
            }
    }
    
    private func fetchTeacher(for teacherID: String, completion: @escaping (Teacher?) -> Void) {
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
            
            let teacher = Teacher(Name: data["Name"] as? String ?? "Unknown", teacherID: teacherID)
            completion(teacher)
        }
    }
}
