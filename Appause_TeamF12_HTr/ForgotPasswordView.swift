//
//  ForgotPasswordView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Binding var showNextView: DisplayState
    var body: some View {
        Text("Forgot Password")
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    
    @State static private var showNextView: DisplayState = .emailCode
    
    static var previews: some View {
        ForgotPasswordView(showNextView: $showNextView)
    }
}
