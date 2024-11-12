import SwiftUI
import Foundation
import FirebaseFirestore

// MARK: - Enrolled Class View
struct EnrolledClassView: View {
    @Binding var showNextView: DisplayState
    @ObservedObject private var firestoreManager = FirestoreManager()
    var studentEmail: String

    var body: some View {
        NavigationView {
            VStack {
                // MAIN / CLASSES Button at the top center
                Button(action: {
                    withAnimation {
                        showNextView = .mainStudent
                    }
                }) {
                    Text("MAIN / CLASSES")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 10)
                
                // Enrolled Classes title at the top left
                HStack {
                    Text("Enrolled Classes")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    Spacer()
                }

                // List of Enrolled Classes
                if firestoreManager.enrolledClass.isEmpty {
                    Text("No enrolled classes found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(firestoreManager.enrolledClass, id: \.0.classID) { (classItem, teacher) in
                        VStack(alignment: .leading) {
                            Text(classItem.className)
                                .font(.headline)
                            Text("Days: \(classItem.days.joined(separator: ", "))")
                            Text("Time: \(formattedClassTime(classItem.classTime))")
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
                        .padding()
                    }
                }

                Spacer()
                
                // New Class Button at the bottom left
                HStack {
                    NavigationLink(destination: StudentConnectCodeView()
                        .navigationBarHidden(true)) {
                        HStack {
                            Text("+")
                                .font(.system(size: 30))
                                .padding(.leading, 5)
                            Text("New Class")
                                .font(.system(size: 25))
                        }
                        .padding(5)
                        .foregroundColor(Color("BlackWhite"))
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
                .padding(.leading, 20)
            }
            .onAppear {
                print("EnrolledClassView appeared. Calling fetchEnrolledClass for email: \(studentEmail)")
                firestoreManager.fetchEnrolledClass(for: studentEmail)
            }
        }
    }
}

// MARK: - Helper Functions
private func formattedClassTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    return formatter.string(from: date)
}

// MARK: - Preview
struct EnrolledClassView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .enrolledClass

    static var previews: some View {
        EnrolledClassView(showNextView: $showNextView, studentEmail: "sample@student.com")
    }
}

