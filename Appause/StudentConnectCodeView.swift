//
//  StudentConnectCodeView.swift
//  Appause
//
//  Created by Huy Tran on 4/18/24.
//  Modified by Dakshina EW on 11/05/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct StudentConnectCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode

    @State private var classID: String = ""
    @State private var classIDError = false
    @State private var connectionMessage: String?
    @State private var isSuccess = false

    private let db = Firestore.firestore()
    private let studentEmail: String? = Auth.auth().currentUser?.email

    var body: some View {
        VStack(spacing: 16) {
            Text("MAIN / MY CLASSES / ADD CLASS")
                .onTapGesture {
                    withAnimation { self.presentationMode.wrappedValue.dismiss() }
                }
                .fontWeight(btnStyle.getFont())
                .foregroundColor(btnStyle.getPathFontColor())
                .frame(width: btnStyle.getWidth(),
                       height: btnStyle.getHeight(),
                       alignment: btnStyle.getAlignment())
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                .padding(.top, 20)

            Spacer()

            Text("Class ID")
                .font(.title)
                .padding(.top, 20)

            VStack(alignment: .leading, spacing: 5) {
                TextField("Insert Class ID Here", text: $classID)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                if classIDError {
                    Text("Class ID is required")
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }

            Button(action: validateAndSubmit) {
                Text("Submit Class ID")
                    .padding()
                    .foregroundColor(.white)
                    .background(btnStyle.getPathColor())
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .fontWeight(btnStyle.getFont())

            if let message = connectionMessage {
                Text(message)
                    .foregroundColor(isSuccess ? .green : .red)
                    .padding(.top)
            }

            Spacer()
        }
        .preferredColorScheme(btnStyle.getStudentScheme() == 0 ? .light : .dark)
    }

    private func validateAndSubmit() {
        classIDError = classID.isEmpty
        connectionMessage = nil

        if classIDError {
            connectionMessage = "Class ID is required"
            isSuccess = false
            return
        }

        // Proceed with Firestore validation using email
        validateClassID()
    }

    private func validateClassID() {
        db.collection("classes").whereField("classID", isEqualTo: classID).getDocuments { snapshot, error in
            if let error = error {
                connectionMessage = "Error finding Class ID: \(error.localizedDescription)"
                isSuccess = false
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                connectionMessage = "Class ID not found"
                isSuccess = false
                return
            }

            // Class ID exists, now validate Student Email
            validateStudentEmail()
        }
    }

    private func validateStudentEmail() {
        guard let email = studentEmail else {
            connectionMessage = "Student email not available"
            isSuccess = false
            return
        }

        db.collection("Users").whereField("Email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                connectionMessage = "Error finding student email: \(error.localizedDescription)"
                isSuccess = false
                return
            }

            guard let document = snapshot?.documents.first else {
                connectionMessage = "Student email not found in database"
                isSuccess = false
                return
            }

            // Student email exists, now add Class ID to `enrolledClasses`
            addClassIDToStudent(documentID: document.documentID)
        }
    }

    private func addClassIDToStudent(documentID: String) {
        db.collection("Users").document(documentID).updateData([
            "enrolledClasses": FieldValue.arrayUnion([classID])
        ]) { error in
            if let error = error {
                connectionMessage = "Failed to connect to class: \(error.localizedDescription)"
                isSuccess = false
            } else {
                connectionMessage = "Connected successfully!"
                isSuccess = true
            }
        }
    }
}

struct StudentConnectCodeView_Previews: PreviewProvider {
    static var previews: some View {
        StudentConnectCodeView()
    }
}
