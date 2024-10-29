import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct registerClassView: View {
    @Binding var showNextView: DisplayState
    @State private var classID = ""
    @State private var className = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var message = ""
    @State private var messageColor = Color.black
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("MAIN / CLASSES / Register ClassID")
                .onTapGesture {withAnimation{self.presentationMode.wrappedValue.dismiss()}}
                .fontWeight(btnStyle.getFont())
                .foregroundColor(btnStyle.getPathFontColor())
                .frame(width: btnStyle.getWidth(),
                        height: btnStyle.getHeight(),
                        alignment: btnStyle.getAlignment())
                
            
            .padding()
            .background(btnStyle.getPathColor())
            .cornerRadius(btnStyle.getPathRadius())
            .padding(.top)
            Spacer()

            TextField("Enter class ID", text: $classID)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Enter class name", text: $className)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                .padding()

            DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                .padding()

            Spacer()

            Button(action: {
                registerForClass(classID: classID, className: className, startTime: startTime, endTime: endTime)
            }) {
                Text("Register")
                    .padding()
                    .fontWeight(.bold)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.leading, 200)
                    .frame(maxWidth: .infinity)
            }

            Spacer()
                .frame(height: 100)

            Text(message)
                .foregroundColor(messageColor)
                .padding()
        }
        .padding(.bottom, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func registerForClass(classID: String, className: String, startTime: Date, endTime: Date) {
        guard let studentID = Auth.auth().currentUser?.uid else {
            message = "Please login."
            messageColor = .red
            return
        }

        let db = Firestore.firestore()
        let studentRef = db.collection("Users").document(studentID)
        let classTakenRef = studentRef.collection("classesTaken").document(classID)

        classTakenRef.setData([
            "classID": classID,
            "className": className,
            "startTime": startTime,
            "endTime": endTime,
            "timestamp": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                message = "Error: \(error.localizedDescription)"
                messageColor = .red
            } else {
                message = "Successfully Registered: \(classID)"
                messageColor = .red
            }
        }
    }
}

struct registerClassView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .registerClass

    static var previews: some View {
        registerClassView(showNextView: $showNextView)
    }
}
