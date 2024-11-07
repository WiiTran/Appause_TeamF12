//
//  TeacherClassListView.swift
//  Appause
//
//  Created by Dash on 11/5/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TeacherClassListView: View {
    @State private var classes: [TeacherClass] = []
    @State private var errorMessage: String? = nil

    private let db = Firestore.firestore()
    private let teacherEmail: String? = Auth.auth().currentUser?.email  // Get the logged-in teacher's email

    var body: some View {
        VStack {
            Text("My Classes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if classes.isEmpty {
                Text("No classes available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(classes.sorted { ($0.period ?? Int.max) < ($1.period ?? Int.max) }) { classItem in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Class ID: \(classItem.classID)")
                            .font(.headline)
                        Text("Class Name: \(classItem.className)")
                        if let period = classItem.period {
                            Text("Period: \(period)")
                        }
                        Text("Days: \(classItem.days.joined(separator: ", "))")
                        Text("Time: \(classItem.startTime) - \(classItem.endTime)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.vertical, 4)
                }
            }
        }
        .onAppear(perform: loadTeacherClasses)
        .padding()
    }

    private func loadTeacherClasses() {
        guard let email = teacherEmail else {
            errorMessage = "Teacher email not available"
            return
        }

        db.collection("Teachers").whereField("Email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to load teacher data: \(error.localizedDescription)"
                return
            }

            guard let teacherDoc = snapshot?.documents.first else {
                self.errorMessage = "Teacher data not found"
                return
            }

            let classesTaught = teacherDoc["classesTaught"] as? [String] ?? []

            fetchClasses(for: classesTaught)
        }
    }

    private func fetchClasses(for classIDs: [String]) {
        let classCollection = db.collection("classes")
        var fetchedClasses: [TeacherClass] = []
        let dispatchGroup = DispatchGroup()

        for classID in classIDs {
            dispatchGroup.enter()
            classCollection.whereField("classID", isEqualTo: classID).getDocuments { snapshot, error in
                defer { dispatchGroup.leave() }

                if let error = error {
                    print("Error fetching class \(classID): \(error.localizedDescription)")
                    return
                }

                guard let classDoc = snapshot?.documents.first else {
                    print("Class ID \(classID) not found in classes collection")
                    return
                }

                let classData = classDoc.data()
                let classItem = TeacherClass(
                    classID: classData["classID"] as? String ?? "",
                    className: classData["className"] as? String ?? "Unknown",
                    period: classData["period"] as? Int,
                    days: classData["days"] as? [String] ?? [],
                    startTime: classData["startTime"] as? String ?? "",
                    endTime: classData["endTime"] as? String ?? ""
                )

                fetchedClasses.append(classItem)
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.classes = fetchedClasses
        }
    }
}

// Model to represent class data
struct TeacherClass: Identifiable {
    var id = UUID()
    var classID: String
    var className: String
    var period: Int?
    var days: [String]
    var startTime: String
    var endTime: String
}

struct TeacherClassListView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherClassListView()
    }
}
