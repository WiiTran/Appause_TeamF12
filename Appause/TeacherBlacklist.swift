//
//  TeacherBlacklist.swift
//  Appause
//
//  Created by Huy Tran on 4/23/24.
//  Revisited by Huy Tran on 11/4/24
import SwiftUI
import Firebase
import FirebaseFirestore

struct TeacherBlacklistApp: View {
    @State var request: RequestData
    @State var studentName: String
   
    var body: some View {
        HStack {
            Image(systemName: "lock.slash")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.red)
            
            Spacer()
            
            NavigationLink(destination: TeacherAppDescription(appData: request)
                .navigationBarHidden(true)) {
                Text(request.appName)
                    .frame(alignment: .center)
                    .padding(.leading, -25)
            }
            Spacer()
                
            Button(action: { // Approve
                request.approved = .approved
            }) {
                if request.approved == ApproveStatus.approved {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "hand.thumbsup")
                        .foregroundColor(.green)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.leading, 10)

            Button(action: { // Deny
                request.approved = .denied
            }) {
                if request.approved == ApproveStatus.denied {
                    Image(systemName: "hand.thumbsdown.fill")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "hand.thumbsdown")
                        .foregroundColor(.red)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

// TeacherBlacklist View
struct TeacherBlacklist: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchAppName: String = ""
    @State private var newAppName: String = ""
    @State private var isAddingNewApp: Bool = false
    var userName = "User"
    @State var appList: [RequestData] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: { dismiss() }) {
                    Text("MAIN / BLACKLIST")
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

                Text("Blacklisted Apps")
                    .padding(.top, 50)
                    .padding(.bottom, 5)

                TextField("Search", text: $searchAppName)
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1))
                    .frame(maxWidth: UIScreen.main.bounds.size.width * 0.75)

                List {
                    ForEach(appList) { request in
                        if searchAppName.isEmpty || request.appName.contains(searchAppName) {
                            TeacherBlacklistApp(request: request, studentName: userName)
                        }
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(lineWidth: 3))
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.85,
                       maxHeight: UIScreen.main.bounds.size.height * 0.7)

                if isAddingNewApp {
                    TextField("Enter App Name", text: $newAppName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.bottom, 10)

                    Button(action: {
                        guard !newAppName.isEmpty else {
                            print("App name is required.")
                            return
                        }

                        let newRequestData = RequestData(documentID: UUID().uuidString, appName: newAppName, studentID: "", approved: ApproveStatus.denied)

                        // Append to the local appList to immediately update UI
                        appList.append(newRequestData)

                        // Write to Firestore
                        addAppToBlacklist(newRequestData)

                        // Clear the text field and hide input
                        newAppName = ""
                        isAddingNewApp = false
                    }) {
                        Text("Confirm")
                            .padding()
                            .fontWeight(btnStyle.getFont())
                            .background(btnStyle.getPathColor())
                            .foregroundColor(btnStyle.getPathFontColor())
                            .cornerRadius(25)
                    }
                    .padding(.top, 10)
                } else {
                    Button(action: {
                        isAddingNewApp = true
                    }) {
                        Text("+ New")
                            .padding()
                            .fontWeight(btnStyle.getFont())
                            .background(btnStyle.getPathColor())
                            .foregroundColor(btnStyle.getPathFontColor())
                            .cornerRadius(25)
                    }
                    .padding(.top, 10)
                }
            }
            .onAppear {
                fetchBlacklistData()
            }
        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
    
    // Function to Add New App to Firestore (Blacklists collection)
    func addAppToBlacklist(_ requestData: RequestData) {
        let db = Firestore.firestore()
        
        let blacklistData: [String: Any] = [
            "appName": requestData.appName,
            "approvalStatus": requestData.approved.rawValue
        ]
        
        db.collection("Blacklists").document(requestData.documentID).setData(blacklistData) { error in
            if let error = error {
                print("Error adding document to Blacklists: \(error)")
            } else {
                print("Document successfully added to Blacklists.")
                
                // Optionally: fetch data again to ensure consistency with Firestore
                fetchBlacklistData()
            }
        }
    }
    
    // Function to Fetch Data from Firestore (Blacklists collection)
    func fetchBlacklistData() {
        let db = Firestore.firestore()

        db.collection("Blacklists").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                appList = querySnapshot?.documents.compactMap { document -> RequestData? in
                    let data = document.data()
                    let documentID = document.documentID
                    guard let appName = data["appName"] as? String,
                          let approvalStatusString = data["approvalStatus"] as? String,
                          let approvalStatus = ApproveStatus(rawValue: approvalStatusString) else {
                        return nil
                    }
                    // Update the data without requiring studentID
                    return RequestData(documentID: documentID, appName: appName, studentID: "", approved: approvalStatus)
                } ?? []
            }
        }
    }
}

struct TeacherBlacklist_Previews: PreviewProvider {
    static var previews: some View {
        TeacherBlacklist()
    }
}
