//
//  TeacherMainView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//

import SwiftUI

struct StudentChooseAdminView: View {
    @Binding var showNextView: DisplayState
    var body: some View {
        Text("Student Manage Classes")
    }
}

struct StudentChooseAdminView_Previews: PreviewProvider {
        @State static private var showNextView: DisplayState = .studentChooseAdmin

        static var previews: some View {
            StudentChooseAdminView(showNextView: $showNextView)
        }

}
