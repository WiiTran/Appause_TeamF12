//
//  TeacherAppDescription.swift
//  Appause_TeamF12_
//
//  Created by Huy Tran on 4/23/24.
// Revisited by Huy Tran on 10/28/24

import SwiftUI
import Firebase
import FirebaseFirestore

// Move RadioThumb struct before TeacherAppDescription
struct RadioThumb: View {
    @Binding var inputStatus: ApproveStatus
    var selectStatus: ApproveStatus
    var color: Color
    var symbol: String
    
    var body: some View {
        Button(action: { self.inputStatus = selectStatus }) {
            Image(systemName: inputStatus == selectStatus ? symbol + ".fill" : symbol)
                .font(.system(size: 30))
        }
        .accentColor(self.color)
    }
}

struct TeacherAppDescription: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appData: RequestData
    @State var parentNavText = "MANAGE USER / "
    @State var studentName = "Student"
    @State var requestReason = "Generic Request Reason"
    @State private var hours = 0
    @State private var minutes = 0
    @State private var showAlert = false
    @State var chosenApprove: ApproveStatus = .unprocessed
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            Button(action: { dismiss() }) {
                Text(parentNavText + studentName + " / " + appData.appName)
                    .textCase(.uppercase)
            }
            .buttonStyle()
            
            Text(studentName + " is requesting access to " + appData.appName + ".")
                .bold()
                .padding(.top)
            
            ZStack {
                VStack {
                    HStack {
                        Image(systemName: "applelogo")
                        Text(appData.appName)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom)
                    Text(appData.appDescription)
                }
                .padding()
            }
            .border(Color("BlackWhite"), width: 3)
            
            Text("Provided Reason for Request")
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text(requestReason)
                .padding()
                .border(Color("BlackWhite"), width: 2)
            
            Text("Allow access to this app?")
                .padding(.top)
            
            HStack(spacing: 90) {
                RadioThumb(inputStatus: $chosenApprove, selectStatus: ApproveStatus.approved, color: .green, symbol: "hand.thumbsup")
                RadioThumb(inputStatus: $chosenApprove, selectStatus: ApproveStatus.approvedTemporary, color: .yellow, symbol: "hand.thumbsup")
                RadioThumb(inputStatus: $chosenApprove, selectStatus: ApproveStatus.denied, color: .red, symbol: "hand.thumbsdown")
            }
            
            if chosenApprove == ApproveStatus.approvedTemporary {
                HStack {
                    VStack {
                        Text("Hours")
                            .padding(.bottom, -5)
                        TextField("Hours", value: $hours, format: .number)
                            .multilineTextAlignment(.center)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("BlackWhite"), lineWidth: 2))
                    }
                    .padding(.leading)
                    VStack {
                        Text("Minutes")
                            .padding(.bottom, -5)
                        TextField("Minutes", value: $minutes, format: .number)
                            .multilineTextAlignment(.center)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("BlackWhite"), lineWidth: 2))
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)
            }
            
            Spacer()
            
            if chosenApprove != ApproveStatus.unprocessed {
                Button(action: {
                    switch chosenApprove {
                        case ApproveStatus.approved:
                            appData.approvedDuration = .infinity
                            updateRequestStatusInFirestore(status: "approved")
                        case ApproveStatus.approvedTemporary:
                            if ((hours == 0 && minutes == 0) || (hours < 0 || minutes < 0)) {
                                showAlert = true
                                return
                            } else {
                                appData.approvedDuration = Float(hours * 60 + minutes)
                                updateRequestStatusInFirestore(status: "approvedTemporary")
                            }
                        case ApproveStatus.denied:
                            appData.approvedDuration = 0
                            updateRequestStatusInFirestore(status: "denied")
                        case ApproveStatus.unprocessed:
                            return
                    }
                    appData.approved = chosenApprove
                    dismiss()
                }) {
                    Text("Confirm")
                    Image(systemName: "checkmark")
                }
                .buttonStyle()
                .alert("Duration should be longer than 0 minutes.", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
        .onAppear {
            fetchRequestReason() // Fetch the reason when the view appears
        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
    
    // New Function to Update Firestore
    func updateRequestStatusInFirestore(status: String) {
        let db = Firestore.firestore()
        
        // Update the original request status in the `unblockRequests` collection
        db.collection("unblockRequests").document(appData.documentID).updateData([
            "status": status,
            "approvedDuration": (chosenApprove == .approvedTemporary) ? (hours * 60 + minutes) : 0 // Save duration only if temporary approval
        ]) { error in
            if let error = error {
                print("Error updating document in unblockRequests: \(error)")
            } else {
                print("Document in unblockRequests successfully updated.")
                
                // Prepare the data to be moved to Whitelist or Blacklist
                var listData: [String: Any] = [
                    "studentID": appData.studentID,
                    "appName": appData.appName,
                    "approvalStatus": status,
                    "approvedTimestamp": FieldValue.serverTimestamp(),
                    "approvedDuration": (chosenApprove == .approvedTemporary) ? (hours * 60 + minutes) : 0// Save duration only if temporary approval
                ]
                // Set expiry timestamp if approved temporarily
                           if status == "approvedTemporary" {
                               let expiryDate = Calendar.current.date(byAdding: .minute, value: hours * 60 + minutes, to: Date()) ?? Date()
                               let expiryTimestamp = Timestamp(date: expiryDate)
                               listData["expiryTimestamp"] = expiryTimestamp // Add expiry timestamp to the listData
                           }
                
                if status == "denied" {
                    // If the request is denied, add it to the `Blacklists` collection
                    db.runTransaction({ (transaction, errorPointer) -> Any? in
                        let unblockRequestRef = db.collection("unblockRequests").document(appData.documentID)
                        let blacklistRef = db.collection("Blacklists").document()
                        
                        // Add the denial to the `Blacklists` collection
                        transaction.setData(listData, forDocument: blacklistRef)
                        
                        // Delete the original request from `unblockRequests`
                        transaction.deleteDocument(unblockRequestRef)
                        
                        return nil
                    }) { (object, error) in
                        if let error = error {
                            print("Error in transaction: \(error)")
                        } else {
                            print("Transaction successfully committed: Document added to Blacklists and deleted from unblockRequests.")
                        }
                    }
                } else {
                    // If the request is approved, add it to the `Whitelists` collection
                    db.runTransaction({ (transaction, errorPointer) -> Any? in
                        let unblockRequestRef = db.collection("unblockRequests").document(appData.documentID)
                        let whitelistRef = db.collection("Whitelists").document()
                        
                        // Add the approval to the `Whitelists` collection
                        transaction.setData(listData, forDocument: whitelistRef)
                        
                        // Delete the original request from `unblockRequests`
                        transaction.deleteDocument(unblockRequestRef)
                        
                        return nil
                    }) { (object, error) in
                        if let error = error {
                            print("Error in transaction: \(error)")
                        } else {
                            print("Transaction successfully committed: Document added to Whitelists and deleted from unblockRequests.")
                        }
                    }
                }
            }
        }
    }
    
    // Function to Fetch Request Reason
    func fetchRequestReason() {
        let db = Firestore.firestore()
        
        db.collection("unblockRequests")
            .document(appData.documentID)
            .getDocument { (document, error) in
                if let error = error {
                    print("Error fetching request details: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    if let reason = document.data()?["reason"] as? String {
                        self.requestReason = reason
                    } else {
                        self.requestReason = "No reason provided."
                    }
                } else {
                    self.requestReason = "Request not found."
                }
            }
    }
}

extension View {
    func buttonStyle() -> some View {
        self
            .fontWeight(btnStyle.getFont())
            .foregroundColor(btnStyle.getPathFontColor())
            .frame(width: btnStyle.getWidth(),
                   height: btnStyle.getHeight(),
                   alignment: btnStyle.getAlignment())
            .padding()
            .background(btnStyle.getPathColor())
            .cornerRadius(btnStyle.getPathRadius())
    }
}

struct TeacherAppApproval_Previews: PreviewProvider {
    static var previews: some View {
        let appData = RequestData(documentID: "testDocumentID", appName: "App", studentID: "student123", approved: ApproveStatus.unprocessed)
        TeacherAppDescription(appData: appData)
    }
}
