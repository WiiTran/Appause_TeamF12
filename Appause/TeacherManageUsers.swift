//
//  TeacherManageUsers.swift
//  Appause
//  Created by Huy Tran on 4/23/24.
import SwiftUI

struct TeacherManageUsers: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var studentName = ""

    var body: some View {
        NavigationStack {
            VStack {
                // Header Button to dismiss the view
                Button(action: { dismiss() }) {
                    Text("MAIN / MANAGE USERS")
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                }
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                .padding(.top)

                // Title for users section
                Text("Students")
                    .font(.title)
                    .padding(.bottom, 10)

                // Search Bar for Filtering Students
                TextField("Search for Registered Users", text: $studentName)
                    .multilineTextAlignment(.center)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke())
                    .frame(maxWidth: UIScreen.main.bounds.size.width * 0.75)

                // List of Students
                List(filteredStudents(), id: \.studentId) { student in
                    VStack(alignment: .leading) {
                        Text(student.Name)
                            .font(.headline)
                        Text("StudentID: \(String(student.email.prefix(6)))")
                            .font(.subheadline)
                        
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Take up full available space
            }
            .onAppear {
                firestoreManager.fetchStudents()
            }
        }
        .toolbar(.hidden)  // Hides the navigation bar
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the main view take up the entire screen
    }
    
    // Helper function to filter students by name based on search input
    func filteredStudents() -> [ClassStudent] {
        if studentName.isEmpty {
            return firestoreManager.Students
        } else {
            return firestoreManager.Students.filter { student in
                student.Name.lowercased().contains(studentName.lowercased())
            }
        }
    }
}

struct TeacherManageUsers_Previews: PreviewProvider {
    static var previews: some View {
        TeacherManageUsers()
            .environmentObject(FirestoreManager())
    }
}
