////
////  studentRequestUnlockView.swift
////  Appause
////
////  Created by Tran Chi on 10/15/24.
////
//
//import SwiftUI
//
//struct UnlockRequestView: View {
//    @State private var unlockReason: String = ""
//    @State private var requestSubmitted: Bool = false
//
//    var body: some View {
//        VStack {
//            Text("Request App Unlock")
//                .font(.headline)
//                .padding()
//
//            TextField("Enter reason for unlock request", text: $unlockReason)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            Button(action: submitRequest) {
//                Text("Submit Request")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//
//            if requestSubmitted {
//                Text("Request submitted successfully!")
//                    .foregroundColor(.green)
//            }
//        }
//        .padding()
//    }
//
//    private func submitRequest() {
//        // Handle request submission logic here
//        // For example, save the request to a database or send it to a server
//
//        // Simulate a successful request submission
//        requestSubmitted = true
//        unlockReason = "" // Clear the input field
//    }
//}
//
//struct UnlockRequestView_Previews: PreviewProvider {
//    static var previews: some View {
//        UnlockRequestView()
//    }
//}
