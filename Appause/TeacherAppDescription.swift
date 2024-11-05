//
//  TeacherAppDescription.swift
//  Appause_TeamF12_
//
//  Created by Huy Tran on 4/23/24.
// Revisited by Huy Tran on 10/28/24


import SwiftUI
import Firebase
import FirebaseFirestore

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
        VStack{
            Button(action: {dismiss()}) {
                Text(parentNavText + studentName + " / " + appData.appName)
                    .textCase(.uppercase)
            }
            .buttonStyle()
            
            Text(studentName + " is requesting access to " + appData.appName + ".")
                .bold()
                .padding(.top)
            
            ZStack{
                VStack{
                    HStack{
                        Image(systemName:"applelogo") //Should use the icon of the app
                        Text(appData.appName)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom)
                    Text(appData.appDescription)
                }
                .padding()
            }
            .border(Color("BlackWhite"), width:3)
            
            Text("Provided Reason for Request")
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text(requestReason)
                .padding()
                .border(Color("BlackWhite"), width:2)
            
            Text("Allow access to this app?")
                .padding(.top)
            
            
            HStack (spacing: 90) {
                RadioThumb(inputStatus: $chosenApprove, selectStatus: ApproveStatus.approved,
                           color: .green, symbol: "hand.thumbsup")
                RadioThumb(inputStatus: $chosenApprove, selectStatus: ApproveStatus.approvedTemporary,
                           color: .yellow, symbol: "hand.thumbsup")
                RadioThumb(inputStatus: $chosenApprove, selectStatus: ApproveStatus.denied,
                           color: .red, symbol: "hand.thumbsdown")
            }
            
            
            
            if chosenApprove == ApproveStatus.approvedTemporary {
                HStack {
                    VStack{
                        Text("Hours")
                            .padding(.bottom, -5)
                        TextField("Hours", value:$hours, format:.number)
                            .multilineTextAlignment(.center)
                            .overlay(RoundedRectangle(cornerRadius:14).stroke(Color("BlackWhite"), lineWidth:2))
                            
                    }
                    .padding(.leading)
                    VStack{
                        Text("Minutes")
                            .padding(.bottom, -5)
                        TextField("Minutes", value:$minutes, format:.number)
                            .multilineTextAlignment(.center)
                            .overlay(RoundedRectangle(cornerRadius:14).stroke(Color("BlackWhite"), lineWidth:2))
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)
            }
            
            Spacer()
            
            if chosenApprove != ApproveStatus.unprocessed {
                            // Updated button action to save decision to Firestore
                            Button(action: {
                                switch chosenApprove {
                                case ApproveStatus.approved:
                                    appData.approvedDuration = .infinity
                                    // Call to update Firestore
                                    updateRequestStatusInFirestore(status: "approved")
                                case ApproveStatus.approvedTemporary:
                                    if ((hours == 0 && minutes == 0) || (hours < 0 || minutes < 0)) {
                                        showAlert = true
                                        return
                                    } else {
                                        appData.approvedDuration = Float(hours * 60 + minutes)
                                        // Call to update Firestore
                                        updateRequestStatusInFirestore(status: "approvedTemporary")
                                    }
                                case ApproveStatus.denied:
                                    appData.approvedDuration = 0
                                    // Call to update Firestore
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
                .alert("Duration should be longer than 0 minutes.", isPresented:$showAlert) {
                    Button("OK", role:.cancel) {}
                }
            }
            
        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
    // New Function to Update Firestore
    func updateRequestStatusInFirestore(status: String) {
            let db = Firestore.firestore()
            db.collection("unblockRequests").document(appData.documentID).updateData([
                "status": status,
                "approvedDuration": (chosenApprove == .approvedTemporary) ? hours * 60 + minutes : nil // Save duration only if temporary approval
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated.")
                }
           }
       }
}



struct RadioThumb : View {
    @Binding var inputStatus: ApproveStatus
    var selectStatus: ApproveStatus
    var color : Color
    var symbol : String
    
    var body: some View {
        Button(action: {self.inputStatus = selectStatus}) {
            Image(systemName: inputStatus == selectStatus ? symbol + ".fill" : symbol)
                .font(.system(size:30))
            
        }
        .accentColor(self.color)
    }
}

extension View {
    func buttonStyle() -> some View {
        self
            .fontWeight(btnStyle.getFont())
            .foregroundColor(btnStyle.getPathFontColor())
            .frame(width:btnStyle.getWidth(),
                   height:btnStyle.getHeight(),
                   alignment:btnStyle.getAlignment())
            .padding()
            .background(btnStyle.getPathColor())
            .cornerRadius(btnStyle.getPathRadius())
    }
}

struct TeacherAppApproval_Previews: PreviewProvider {
    static var previews: some View {
        let appData = RequestData(documentID: "testDocumentID", appName: "App", approved: ApproveStatus.unprocessed)
        TeacherAppDescription(appData: appData)
    }
}
