import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Request: Identifiable {
    var id: String { documentID }
    var documentID: String
    var studentID: String
    var appName: String
    var status: String
    var requestTimestamp: Timestamp
}

struct RequestsView: View {
    @State private var requests: [Request] = []

    var body: some View {
        NavigationView {
            List(requests) { request in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Student ID: \(request.studentID)")
                        Text("App Name: \(request.appName)")
                        Text("Status: \(request.status)")
                        Text("Requested At: \(request.requestTimestamp.dateValue(), formatter: dateFormatter)")
                    }
                    Spacer()
                    if request.status == "pending" {
                        Button("Approve") {
                            approveRequest(requestID: request.documentID)
                        }
                        Button("Reject") {
                            rejectRequest(requestID: request.documentID)
                        }
                    }
                }
            }
            .navigationTitle("Unlock Request Lists") // Set the title here
            .onAppear(perform: fetchRequests)
        }
    }

    func fetchRequests() {
        guard let studentID = Auth.auth().currentUser?.uid else {
            print("No valid student ID found.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("unblockRequests")
            .whereField("studentID", isEqualTo: studentID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    self.requests = querySnapshot?.documents.compactMap { document in
                        let data = document.data()
                        return Request(
                            documentID: document.documentID,
                            studentID: data["studentID"] as? String ?? "",
                            appName: data["appName"] as? String ?? "",
                            status: data["status"] as? String ?? "",
                            requestTimestamp: data["requestTimestamp"] as? Timestamp ?? Timestamp(date: Date())
                        )
                    } ?? []
                }
            }
    }

    func approveRequest(requestID: String) {
        let db = Firestore.firestore()
        db.collection("unblockRequests").document(requestID).updateData(["status": "approved"]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Request approved successfully.")
                fetchRequests() // Refresh the list after approval
            }
        }
    }
    
    func rejectRequest(requestID: String) {
        let db = Firestore.firestore()
        db.collection("unblockRequests").document(requestID).updateData(["status": "rejected"]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Request rejected successfully.")
                fetchRequests() // Refresh the list after rejection
            }
        }
    }
}

// Date Formatter
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

// Preview
struct RequestsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestsView()
    }
}
