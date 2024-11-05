//
//  enrolledClassView.swift
//  Appause
//
//  Created by Tran Chi on 10/15/24.

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore
//import FirebaseFirestoreCombineSwift

import SwiftUI
import FirebaseFirestore

struct enrolledClassView: View {
    @Binding var showNextView: DisplayState
    @StateObject private var firestoreManager = FirestoreManager()
    var StudentID: String // Assuming you pass the student ID to this view

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    withAnimation {
                        showNextView = .mainStudent
                    }
                }) {
                    Text("MAIN / CLASSES")
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                }
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                .padding(.bottom, 20)

                // List of Enrolled Classes
                    
                    List(firestoreManager.enrolledClass, id: \.0.id) { classItem, teacher in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(classItem.className)
                                            Text("Days: \(classItem.days.joined(separator: ", "))")
                                            
                                            Text("Time: \(formattedClassTime(classItem.classTime))")                                               .font(.title2)
                                            if let teacher = teacher {
                                                Text("Teacher: \(teacher.Name)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text("Teacher: Unknown")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }.onAppear {
                                    firestoreManager.fetchEnrolledClass(for: StudentID)
                                }
               // NavigationLink(destination: ClassIDGenerationView(enrolledClass: //$firestoreManager.enrolledClass).environmentObject(firestoreManager)) {
                    //Text("View Enrolled Classes")
                //}

                // New Class Button
                NavigationLink(destination: StudentConnectCodeView()
                    .navigationBarHidden(true)) {
                    ZStack {
                        Text("+")
                            .font(.system(size: 30))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                        Text("New Class")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 25))
                    }
                    .padding(5)
                    .foregroundColor(Color("BlackWhite"))
                }
                .padding(.top)
            }
            //.navigationTitle("ClassTaken")
            //.navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(btnStyle.getStudentScheme() == 0 ? .light : .dark)
    }
}
private func formattedClassTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    return formatter.string(from: date)
}

struct ClassDataView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .enrolledClass

    static var previews: some View {
        enrolledClassView(showNextView: $showNextView, StudentID: "sampleStudentId")
    }
}


