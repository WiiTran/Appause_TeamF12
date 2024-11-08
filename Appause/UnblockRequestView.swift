import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct UnblockRequestView: View {
    @Binding var showNextView: DisplayState
    @State private var reason: String = ""
    @State private var requestStatus: String = "Pending"
    @State private var studentID: String = ""
    @State private var appName: String = ""
    @State private var shouldNavigateToMainMenu = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                // NavigationLink using a value-based navigation and NavigationStack
                NavigationLink(value: shouldNavigateToMainMenu) {
                    EmptyView()
                }
                .navigationDestination(isPresented: $shouldNavigateToMainMenu) {
                    StudentMainView(showNextView: $showNextView)
                }

                Button(action: {
                    withAnimation {
                        shouldNavigateToMainMenu = true // Trigger navigation to the main menu
                    }
                }) {
                    Text("MAIN / Submitting Request")
                        .foregroundColor(btnStyle.getPathFontColor())
                        .fontWeight(btnStyle.getFont())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                }
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                .padding(.top)
                
                Spacer()

                TextField("Student ID", text: $studentID)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("App Name", text: $appName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Reason for unblocking", text: $reason)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Submit Request") {
                    submitRequest()
                }
                .padding()

                Text("Current Status: \(requestStatus)")
                    .padding()

                Button("Check Status") {
                    checkRequestStatus()
                }
                .padding()

                Spacer()
            }
            .padding() // Add padding around the whole VStack
        }
    }

    func getCurrentStudentID() -> String? {
        return Auth.auth().currentUser?.uid
    }

    // Function to submit the unblock request
    func submitRequest() {
        guard !studentID.isEmpty, !appName.isEmpty, !reason.isEmpty else {
            print("Please fill in all fields.")
            return
        }

        let db = Firestore.firestore()

        let requestData: [String: Any] = [
            "studentID": studentID,
            "appName": appName,
            "status": "pending",
            "requestTimestamp": FieldValue.serverTimestamp(),
            "reason": reason
        ]

        db.collection("unblockRequests").addDocument(data: requestData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Request submitted successfully.")
                requestStatus = "Pending" // Reset status or update as needed
            }
        }
    }

    // Function to check the request status
    func checkRequestStatus() {
        let db = Firestore.firestore()

        db.collection("unblockRequests")
            .whereField("studentID", isEqualTo: studentID)
            .whereField("appName", isEqualTo: appName)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching status: \(error)")
                    return
                }

                if let documents = querySnapshot?.documents, !documents.isEmpty {
                    // Assuming you want the status of the latest request
                    if let latestRequest = documents.last {
                        if let status = latestRequest.data()["status"] as? String {
                            requestStatus = status
                        } else {
                            requestStatus = "Status not found."
                        }
                    }
                } else {
                    requestStatus = "No requests found."
                }
            }
    }
}

struct UnblockRequestView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .UnblockRequest
    static var previews: some View {
        UnblockRequestView(showNextView: $showNextView)
    }
}
