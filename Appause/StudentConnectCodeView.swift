
//
//  StudentConnectCodeView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/18/24.
//  Modified by Dakshina EW on 11/05/2024.
//

import SwiftUI
import FirebaseFirestore

struct StudentConnectCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode

    @State private var classID: String = ""
    @State private var studentID: String = ""
    @State private var classIDError = false
    @State private var studentIDError = false
    @State private var connectionMessage: String?
    @State private var isSuccess = false

    private let db = Firestore.firestore()

    var body: some View {
        VStack(spacing: 16) {
            Text("MAIN / CLASSES / ADD CLASS")
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
                TextField("Enter Student ID", text: $studentID)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                if studentIDError {
                    Text("Student ID is required")
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }
            
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
        studentIDError = studentID.isEmpty
        connectionMessage = nil

        if classIDError || studentIDError {
            connectionMessage = "Both Class ID and Student ID are required"
            isSuccess = false
            return
        }

        // Proceed with Firestore validation
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

            // Class ID exists, now validate Student ID
            validateStudentID()
        }
    }

    private func validateStudentID() {
        db.collection("Users").whereField("StudentId", isEqualTo: studentID).getDocuments { snapshot, error in
            if let error = error {
                connectionMessage = "Error finding Student ID: \(error.localizedDescription)"
                isSuccess = false
                return
            }

            guard let document = snapshot?.documents.first else {
                connectionMessage = "Student ID not found"
                isSuccess = false
                return
            }

            // Student ID exists, now add Class ID to `classesTaken`
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
