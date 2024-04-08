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
    @State private var codeIn = EmailCode.shared.grabRandCode()
    
    var body: some View
    {
        VStack
        {
            Button(action: {
                withAnimation {
                    showNextView = .mainStudent} //main student is placeholder for proper connections
            }){
                Text("MAIN / PASSWORD RESET")
                    .padding()
                    .fontWeight(.bold)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .frame(width: 300,
                           height: 20,
                           alignment: .center)
            }
            .padding()
            .background(Color.black)
            .border(Color.black, width: 5)
            .cornerRadius(100)
            .padding(.bottom, 30)
            
            Text("Reset Verification Code")
                .font(.title)
                .padding(.top, 25)
            
            
            TextField("Insert Reset Code ", text:$resetCode)
                .padding(25.0)
                .frame(width: 250.0, height: 100.0)
                .disabled(false)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                withAnimation {
                    showNextView = .resetPassword
                }
                if isSameCode(resetCode) {
                    showNextView = .resetPassword
                } else {
                    alertMessage = "Invalid reset code"
                    showAlert = true
                }
            }){
                Text("Submit")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 100, height: 20, alignment: .center)
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .border(Color.black, width: 5)
                    .cornerRadius(6)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding(.bottom, 400)
        .cornerRadius(100)
        }
        
    func isSameCode(_ code: String) -> Bool {
            return code == codeIn
        }
    }

struct PWCodeVerificationView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .mainStudent

    static var previews: some View {
        PWCodeVerificationView(showNextView: $showNextView)
    }
}
