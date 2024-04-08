import SwiftUI
import Combine

struct TwoFactorAuthView: View {
    @Binding var showNextView: DisplayState
    var email: String
    var onVerificationSuccess: () -> Void
    @Binding var show2FAInput: Bool

    @State private var code: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var storedCodes: [String: (code: String, expiration: Date)] = [:]
    @State private var remainingTime: Int = 30 // 10 minutes in seconds
    @State private var timerActive = false // Controls the timer's activation

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        showNextView = .login
                    }
                    show2FAInput = false
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                .padding(.trailing, 350)
            }
            Spacer()

            if timerActive {
                Text("\(remainingTime / 60):\(String(format: "%02d", remainingTime % 60))")
                    .font(.system(size: 50))
                    .foregroundColor(remainingTime > 0 ? .green : .red) // Color changes to red when time is 0
                    .padding(.bottom, 1)
                    .onReceive(timer) { _ in
                        if remainingTime > 0 {
                            remainingTime -= 1
                        }
                    }
            }

            Text("Enter Your Registered Email")
                .font(.title)
                .fontWeight(.bold)

            HStack {
                TextField("Email Address", text: .constant(email))
                    .padding()
                    .foregroundColor(Color.black.opacity(0.3))
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                Button(action: {
                    let generatedCode = generateRandomCode()
                    storeCode(email: email, code: generatedCode)
                    sendEmail(code: generatedCode, email: email)
                    remainingTime = 30 // Reset the timer
                    timerActive = true // Activate the timer
                }) {
                    Text("Send")
                }
            }

            Text("Enter Your 2FA Code")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 10.0)

            TextField("Enter Code", text: $code)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .keyboardType(.numberPad)

            Button(action: {
                if verifyCode(code) {
                    showNextView = .mainTeacher
                    onVerificationSuccess()
                } else {
                    showAlert = true
                    alertMessage = "Invalid code. Please try again."
                }
            }) {
                Text("Verify")
                    .foregroundColor(.white)
                    .frame(width: 330)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.top, 10)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }
        .padding()
    }

    func storeCode(email: String, code: String) {
        let expiration = Calendar.current.date(byAdding: .second, value: 30, to: Date())!
        storedCodes[email] = (code: code, expiration: expiration)
    }

    func verifyCode(_ enteredCode: String) -> Bool {
        guard let storedCode = storedCodes[email] else { return false }
        if Date() > storedCode.expiration {
            storedCodes[email] = nil
            return false
        }
        return enteredCode == storedCode.code
    }
}



func generateRandomCode() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<5).map{ _ in letters.randomElement()! })
}


func sendEmail(code: String, email: String) {
    guard let url = URL(string: "https://api.smtp2go.com/v3/email/send") else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("api-F199C926535F11EE96AEF23C91C88F4E", forHTTPHeaderField: "Key") // Replace with your API key

    let body: [String: Any] = [
        "api_key": "api-F199C926535F11EE96AEF23C91C88F4E", // Your API key
        "to": ["<\(email)>"], // The recipient's email address, formatted correctly
        "sender": "appaused.service@gmail.com", // Our service email address
        "subject": "Your Verification Code",
        "text_body": "Your verification code is: \(code)",
        "html_body": "<p>Your verification code is: \(code)</p>"
    ]

    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error sending email: \(error)")
            return
        }
        
        if let response = response as? HTTPURLResponse {
            print("Response status code: \(response.statusCode)")
            if let data = data, let body = String(data: data, encoding: .utf8) {
                print("Response body: \(body)")
            }
        }
    }

    task.resume()
}



struct TwoFactorAuthView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .twoFactorAuth
    @State static private var show2FA: Bool = true
    
    static var previews: some View {
        TwoFactorAuthView(showNextView: $showNextView, email: "test@example.com", onVerificationSuccess: {
            print("Verification successful!")
        }, show2FAInput: $show2FA)
    }
}
