//
//  PWCodeVerification.swift
//  Project190
//
//  Created by Alec on 9/15/23.
//

import Foundation
import SwiftUI
import Combine

struct PWCodeVerificationView: View
{
    //Add this binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    
    @State private var resetCode: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var codeIn = ForgotPassword.shared.codeIn
    @StateObject var timerViewModel = TimerViewModel()
    
    //environment variable used in navigation when the back button is pressed
    @EnvironmentObject var viewSwitcher: ViewSwitcher
    
    var body: some View
    {
        VStack {
            Spacer()
            HStack{
                Spacer()
                Button(action:{
                    /* depending on which page the user leaves when resetting their password, the back button brings them
                     to the same page that they were at before they entered the password reset process */
                    if(viewSwitcher.lastView == "studentSettings"){
                        withAnimation {
                            showNextView = .studentSettings
                        }
                    }
                    if(viewSwitcher.lastView == "teacherSettings"){
                        withAnimation {
                            showNextView = .teacherSettings
                        }
                    }
                    if(viewSwitcher.lastView == "login"){
                        withAnimation {
                            showNextView = .login
                        }
                    }
                }){
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                .padding(.top, 200)
                .padding(.trailing, 350)
                .padding(.bottom, 90)
                //Spacer()
            }
            
            Spacer()
            
            Text(timerViewModel.timeString)
                .font(.system(size: 50))
                .foregroundColor(Color.green)
                .padding(.bottom, 20) // Adjust padding as needed
            
            Text("Verify Email")
                .padding()
                .fontWeight(.bold)
                .font(.system(size: 45))
            
            Image(systemName: "mail.and.text.magnifyingglass")
                .fontWeight(.bold)
                .font(.system(size:100))
                .padding(.bottom)
            
            Text("To verify yourself, please enter the code that was sent to your email")
                .font(.body)
                .multilineTextAlignment(.center)
                .lineLimit(2, reservesSpace: true)
                .fontWeight(.bold)
            
            TextField("Insert Reset Code", text:$resetCode)
                .padding()
                .disabled(false)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(width: 370)
                .padding(.vertical, 25.0)
                .autocapitalization(.none)
            
            Button(action: {
                if resetCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    alertMessage = "Please enter a reset code"
                    showAlert = true
                } else if isSameCode(resetCode) {
                    withAnimation {
                        showNextView = .resetPassword
                    }
                } else {
                    alertMessage = "Invalid reset code"
                    showAlert = true
                }
            }) {
                Text("Submit Code")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 340)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                .padding(.top, -15.0)
            }
            Spacer()
                .disabled(resetCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // This disables the button when resetCode is empty or just contains whitespace.
            
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("ERROR"), message: Text(alertMessage), dismissButton: .default(Text("OKAY")))
                }
        }
        .padding(.bottom, 300)
        .cornerRadius(100)
        .onAppear {
            timerViewModel.startTimer()  // Start the timer when the view appears
        }
        .onDisappear {
            timerViewModel.stopTimer()  // Stop the timer when the view disappears
        }
    }
    
    
    func isSameCode(_ code: String) -> Bool {
        return code == ForgotPassword.shared.codeIn
    }
    
}

struct FiveBoxesShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let boxWidth: CGFloat = rect.width / 5
        for i in 0..<5 {
            let start = CGPoint(x: CGFloat(i) * boxWidth, y: 0)
            let boxRect = CGRect(origin: start, size: CGSize(width: boxWidth, height: rect.height))
            path.addRect(boxRect)
        }
        
        return path
    }
}

struct PWCodeVerificationView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .pwCodeVerification
    
    static var previews: some View {
        PWCodeVerificationView(showNextView: $showNextView)
    }
}
