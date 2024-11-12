//
//  FeedbackFormView.swift
//  Appause
//
//  Created by Abdurraziq on 10/26/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct FeedbackFormView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var userName: String = ""
    @State private var feedbackTitle: String = ""
    @State private var feedbackDetails: String = ""
    @State private var category: String = "Bug Report"
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    @State private var isAuthenticated: Bool = false // Track authentication status
    
    let categories = ["Bug Report", "Improvement Suggestion"]

    var body: some View {
        VStack {
            // Add Back to Main button
            Text("MAIN / FEEDBACK")
                .onTapGesture {
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .fontWeight(btnStyle.getFont())
                .foregroundColor(btnStyle.getPathFontColor())
                .frame(width: btnStyle.getWidth(), height: btnStyle.getHeight(), alignment: btnStyle.getAlignment())
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                .padding(.top)
            
            Form {
                Section(header: Text("User Name")) {
                    TextField("Enter your username", text: $userName)
                }
                Section(header: Text("Feedback Title")) {
                    TextField("Enter a title", text: $feedbackTitle)
                }
                Section(header: Text("Details")) {
                    TextEditor(text: $feedbackDetails)
                        .frame(height: 150)
                        .keyboardType(.default) // Ensure default keyboard type
                }
                Section(header: Text("Category")) {
                    Picker("Select a category", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Button(action: submitFeedback) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Feedback Submission"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .onAppear {
                signInAnonymously() // Ensure the user is authenticated when the view appears
            }
        }
        .navigationTitle("Submit Feedback")
    }

    func submitFeedback() {
        // Check if the user is authenticated
        guard Auth.auth().currentUser != nil else {
            alertMessage = "User is not authenticated. Please try again."
            showingAlert = true
            return
        }

        let feedbackData: [String: Any] = [
            "title": feedbackTitle,
            "details": feedbackDetails,
            "category": category,
            "timestamp": Timestamp()
        ]
        
        let db = Firestore.firestore()
        db.collection("feedback").document(userName).setData(feedbackData) { error in
            if let error = error {
                alertMessage = "Error saving feedback: \(error.localizedDescription)"
                showingAlert = true
            } else {
                alertMessage = "Feedback successfully saved for user: \(userName)"
                showingAlert = true
                clearInputFields() // Clear the fields after saving
            }
        }
    }
    
    func clearInputFields() {
        userName = ""
        feedbackTitle = ""
        feedbackDetails = ""
        category = "Bug Report"
    }

    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Error with anonymous sign-in: \(error.localizedDescription)")
            } else {
                print("User signed in anonymously with UID: \(authResult?.user.uid ?? "")")
                isAuthenticated = true // Set authentication status to true
            }
        }
    }
}

struct FeedbackFormView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackFormView()
    }
}
