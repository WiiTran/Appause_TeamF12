//
//  TeacherManageClasses.swift
//  Appause
//
//  Created by Huy Tran on 11/12/24.
//

import SwiftUI

struct TeacherManageClasses: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header Button to dismiss the view
                Button(action: { dismiss() }) {
                    Text("MAIN / MANAGE CLASSES")
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

                // Title for classes section
                Text("Classes")
                    .font(.title)
                    .padding(.bottom, 10)

                // List of Classes
                List(firestoreManager.classes, id: \.classID) { classItem in
                    VStack(alignment: .leading) {
                        Text(classItem.className)
                            .font(.headline)
                        Text("Teacher: \(classItem.Name)")
                            .font(.subheadline)
                        Text("Class Time: \(formattedTime(classItem.classTime))")
                            .font(.subheadline)
                        Text("Days: \(classItem.days.joined(separator: ", "))")
                            .font(.subheadline)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Take up full available space
            }
            .onAppear {
                firestoreManager.fetchClasses()
            }
        }
        .toolbar(.hidden)  // Hides the navigation bar
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the main view take up the entire screen
    }
        
    // Helper function to format the class time
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct TeacherManageClasses_Previews: PreviewProvider {
    @StateObject var firestoreManager = FirestoreManager()
    
    static var previews: some View {
        TeacherManageClasses()
            .environmentObject(FirestoreManager())
            .environmentObject(StudentList())
    }
}
