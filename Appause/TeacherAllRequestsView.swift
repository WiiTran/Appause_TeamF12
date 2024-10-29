//
//  TeacherAllRequestsView.swift
//  Appause_TeamF12
//
//  Created by Huy Tran on 4/23/24.
// Revisited by Huy Tran on 10/28/24
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct TeacherAllRequestsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var requests: [Request] = [] // Firebase requests array
    @State private var searchAppName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Dismiss button
                Button(action: { dismiss() }) {
                    Text("MAIN / REQUESTS")
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
                
                // Title and search field
                Text("App Requests")
                    .padding(.top, 50)
                    .padding(.bottom, 5)
                
                TextField("Search", text: $searchAppName)
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1))
                    .frame(maxWidth: UIScreen.main.bounds.size.width * 0.75)
                
                // List of requests
                List(filteredRequests) { request in
                    unprocessedRequest(request: request, studentName: request.studentID, searchAppName: searchAppName)
                }
                .overlay(RoundedRectangle(cornerRadius: 10, style: .circular).stroke(lineWidth: 3))
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.85,
                       maxHeight: UIScreen.main.bounds.size.height * 0.7)
            }
        }
        .onAppear(perform: fetchRequests) // Load requests on appear
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
    
    // Computed property to filter requests based on searchAppName
    var filteredRequests: [Request] {
        searchAppName.isEmpty ? requests : requests.filter { $0.appName.contains(searchAppName) }
    }

    // Function to fetch requests from Firebase Firestore
    func fetchRequests() {
        let db = Firestore.firestore()
        db.collection("unblockRequests")
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
}

struct unprocessedRequest: View {
    var request: Request
    @State var studentName: String
    @State var searchAppName: String
    
    var body: some View {
        if request.status == "pending" {
            // Convert `Request` to `RequestData` using the new initializer
            let requestData = RequestData(from: request)
            TeacherAppView(request: requestData, studentName: studentName, parentNavText: "REQUESTS / ")
        }
    }
}

struct TeacherAllRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherAllRequestsView()
    }
}
