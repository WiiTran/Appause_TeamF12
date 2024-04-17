//
//  StudentMainView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//

import SwiftUI

struct StudentMainView: View {
    @Binding var showNextView: DisplayState
    var body: some View {
        Text("Student Main View")
    }
}

struct StudentMainView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .mainStudent

    static var previews: some View {
        StudentMainView(showNextView: $showNextView)
    }
}
