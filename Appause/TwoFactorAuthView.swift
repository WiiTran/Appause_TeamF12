//
//  TwoFactorAuthView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//

import SwiftUI
import Combine


struct TwoFactorAuthView: View {
    @Binding var showNextView: DisplayState
    var email: String
    var onVerificationSuccess: () -> Void
    @Binding var show2FAInput: Bool

    
    var body: some View {
        Text("2 Factor Auth View")
    }
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
