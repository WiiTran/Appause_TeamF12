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

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                // Button to navigate back to the main student view
                Button(action: {
                    withAnimation {
                        showNextView = .mainStudent // Directly update showNextView to navigate back
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

                // Form fields for unblock request
                TextField("Student ID", text: $studentID)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("App Name", text: $appName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Reason for unblocking", text: $reason)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Submit request button
                Button("Submit Request") {
                    submitRequest()
                }
                .padding()

                // Display current request status
                Text("Current Status: \(requestStatus)")
                    .padding()

                // Button to check request status
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
        let expiryDate = Calendar.current.date(byAdding: .hour, value: 72, to: Date()) ?? Date()
        let expiryTimestamp = Timestamp(date: expiryDate)

        let requestData: [String: Any] = [
            "studentID": studentID,
            "appName": appName,
            "status": "pending",
            "requestTimestamp": FieldValue.serverTimestamp(),
            "expiryTimestamp": expiryTimestamp,
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

    // Function to delete expired requests
    func deleteExpiredRequests() {
        let db = Firestore.firestore()
        let now = Timestamp(date: Date())
        db.collection("unblockRequests")
            .whereField("expiryTimestamp", isLessThanOrEqualTo: now)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching expired requests: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No expired documents found.")
                    return
                }

                for document in documents {
                    print("Deleting document with ID: \(document.documentID)")
                    document.reference.delete { error in
                        if let error = error {
                            print("Error deleting document: \(error)")
                        } else {
                            print("Expired request deleted successfully: \(document.documentID)")
                        }
                    }
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
