//
//  TeacherWhitelist.swift
//  Appause
//
//  Created by Huy Tran on 4/23/24.
import SwiftUI
import Firebase
import FirebaseFirestore


struct TeacherWhitelistApp: View {
    @State var request: RequestData
    @State var studentName: String
   
    var body: some View {
        HStack {
            //
            Image(systemName: "lock.open")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.green)
            
            Spacer()
            
            NavigationLink(destination: TeacherAppDescription(appData: request)
                .navigationBarHidden(true)) {
                Text(request.appName)
                        .frame(alignment: .center)
                                            .padding(.leading, -25)
            }
            Spacer()
                
            Button(action: { // Approve
                request = RequestData(documentID: "testID", appName: request.appName, studentID: "223344", approved: ApproveStatus.approved)
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
                request = RequestData(documentID: "testID", appName: request.appName, studentID: "223344", approved: ApproveStatus.denied)
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


//ApproveStatus and RequestData defined in StudentAppRequestView

struct TeacherWhitelist: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchAppName: String = ""
    var userName = "User"
    
    @State var appList: [RequestData] = []
    
    var body: some View {
            NavigationView {
                VStack {
                    Button(action: { dismiss() }) {
                        Text("MAIN / WHITELIST")
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

                    Text("Whitelisted Apps")
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
                                TeacherWhitelistApp(request: request, studentName: userName)
                            }
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                        .stroke(lineWidth: 3))
                    .frame(maxWidth: UIScreen.main.bounds.size.width * 0.85,
                           maxHeight: UIScreen.main.bounds.size.height * 0.7)

                    Button(action: {
                        // Adding a new app to demonstrate functionality
                        let newAppName = "App " + String(appList.count + 1)
                        appList.append(RequestData(documentID: "testID\(appList.count + 1)", appName: newAppName, studentID: "223344", approved: ApproveStatus.unprocessed))
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
                .onAppear {
                    fetchWhitelistData()
                }
            }
            .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
        }
    // Function to Fetch Data from Firestore
        func fetchWhitelistData() {
            let db = Firestore.firestore()

            db.collection("Whitelists").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    appList = querySnapshot?.documents.compactMap { document -> RequestData? in
                        let data = document.data()
                        let documentID = document.documentID
                        guard let appName = data["appName"] as? String,
                              let studentID = data["studentID"] as? String,
                              let approvalStatusString = data["approvalStatus"] as? String,
                              let approvalStatus = ApproveStatus(rawValue: approvalStatusString) else {
                            return nil
                        }
                        return RequestData(documentID: documentID, appName: appName, studentID: studentID, approved: approvalStatus)
                    } ?? []
            }
              }
          }
      }
struct TeacherWhitelist_Previews: PreviewProvider {
    static var previews: some View {
        TeacherWhitelist()
    }
}
