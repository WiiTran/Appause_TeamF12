//
//  TeacherMainView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//

import SwiftUI

struct TeacherMainView: View {
    @Binding var showNextView: DisplayState
    var body: some View {
        Text("Teacher Main View")
    }
}

struct MainTeacherView_Previews: PreviewProvider {
        @State static private var showNextView: DisplayState = .mainTeacher

        static var previews: some View {
            TeacherMainView(showNextView: $showNextView)
        }

}
