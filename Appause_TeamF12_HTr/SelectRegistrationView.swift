//
//  SelectRegistrationView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//

import SwiftUI
import KeychainSwift

struct SelectRegistrationView: View {
    @Binding var showNextView: DisplayState
    var body: some View {
        Text("Select Registration View")
    }
}

struct SelectRegistrationView_Previews: PreviewProvider
{
    @State static private var showNextView: DisplayState = .selectRegistration
    
    static var previews: some View
    {
        SelectRegistrationView(showNextView: $showNextView)
    }
}
