

import FirebaseFirestore
import Combine
import Foundation
import SwiftUI



class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var classesWithTeachers: [(Class, Teacher?)] = [] // List of classes with their teachers

    func fetchClasses() {
        db.collection("ClassTaken")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching classes: \(error.localizedDescription)")
                } else {
                    let classes = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Class.self)
                    } ?? []
                    print("Fetched classes: \(classes)")
                    
                    self.fetchTeachers(for: classes) // Fetch teachers after classes are retrieved
                }
            }
    }

    private func fetchTeachers(for classList: [Class]) {
        let TeacherID = classList.map { $0.Name }
        let uniqueTeacherIds = Array(Set(TeacherID)) // Get unique teacher IDs
        print("Unique teacher IDs: \(uniqueTeacherIds)")
        let group = DispatchGroup()
        var teachers: [String: Teacher] = [:]

        for teacherId in uniqueTeacherIds {
            group.enter()
            db.collection("Teachers").document().getDocument { (document, error) in
                if let document = document, let teacher = try? document.data(as: Teacher.self) {
                    teachers[teacherId] = teacher
                    print("Fetched teacher: \(teacher)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.classesWithTeachers = classList.map { (classItem) -> (Class, Teacher?) in
                return (classItem, teachers[classItem.TeacherID])
            }
        }
    }
}
