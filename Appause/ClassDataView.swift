
import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

import SwiftUI
import FirebaseFirestore

struct ClassDataView: View {
    @Binding var showNextView: DisplayState
    @StateObject private var firestoreManager = FirestoreManager()
    var studentId: String // Assuming you pass the student ID to this view

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

                //Title for Enrolled Classes
                //Text("ClassTaken")
                    //.font(.headline)
                    //.padding()

                // List of Enrolled Classes
                    List(firestoreManager.classesWithTeachers, id: \.0.id) { classItem, teacher in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(classItem.className)
                                                .font(.title2)
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
                                    firestoreManager.fetchClasses()
                                }
                    
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

struct ClassDataView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .studentChooseAdmin

    static var previews: some View {
        ClassDataView(showNextView: $showNextView, studentId: "sampleStudentId")
    }
}
