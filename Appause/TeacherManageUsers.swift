//
//  TeacherManageUsers.swift
//  Appause
//
//  Created by Huy Tran on 4/23/24.
import SwiftUI

struct TeacherManageUsers: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var studentList: StudentList
    @State var studentName = ""
    @State private var selectedStudent: StudentData? = nil

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

                Spacer()

                // Search Bar for Filtering Students
                TextField("Search for Registered Users", text: $studentName)
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1))
                    .frame(maxWidth: UIScreen.main.bounds.size.width * 0.75)
                    .padding(.bottom, 25)
                    .padding(.top, 30)

                // List of Students
                List($studentList.students) { $student in
                    if studentName.isEmpty || student.name.lowercased().contains(studentName.lowercased()) {
                        NavigationLink(value: student) {
                            Text(student.name)
                                .font(.callout)
                                .foregroundColor(btnStyle.getBtnFontColor())
                        }
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(lineWidth: 5))
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.80,
                       maxHeight: UIScreen.main.bounds.size.height * 0.75)
                .padding(.bottom, 300)
                .cornerRadius(5)

            }
            // Navigation Destination to TeacherUserRequestView
            .navigationDestination(for: StudentData.self) { student in
                TeacherUserRequestView(stackingPermitted: .constant(nil), student: student)
                    .navigationBarHidden(true)
            }
        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
}

struct TeacherManageUsers_Previews: PreviewProvider {
    @StateObject var studentList = StudentList()
    static var previews: some View {
        TeacherManageUsers()
            .environmentObject(StudentList())
    }
}
