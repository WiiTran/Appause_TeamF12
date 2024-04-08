// Project190
// MainTeacherView.swift
//  Created by Eduardo Mariano on 4/6/23.
//
//  Purpose: Acts as GUI for the user in order to
//           navigate to specfic features of the app.
//

import SwiftUI

struct TeacherMainView: View {
    //Add this binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    @StateObject var studentList = StudentList()
        
    var body: some View {
        NavigationView {
            VStack{
                // create Main button
                Button(action:{})
                {
                    Text("MAIN")
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                }
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                Spacer()
                
                // create Requests button
                NavigationLink(destination: TeacherAllRequestsView(studentList: studentList)
                    .navigationBarHidden(true)
                    .environmentObject(studentList)) {
                    Text("Requests")
                        .padding(.leading, 25)
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                    
                    Image(systemName: "hand.raised")
                        .fontWeight(btnStyle.getFont())
                        .imageScale(.large)
                        .foregroundColor(btnStyle.getBtnFontColor())
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBtnRadius())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                // create Whitelist button
                NavigationLink(destination: TeacherWhitelist()
                    .navigationBarHidden(true)) {
                    Text("Whitelist")
                        .padding(.leading, 20)
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                    
                    Image(systemName: "bookmark.slash")
                        .fontWeight(btnStyle.getFont())
                        .imageScale(.large)
                        .foregroundColor(btnStyle.getBtnFontColor())
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBtnRadius())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                // create Manage Users button
                NavigationLink(destination: TeacherManageUsers()
                    .navigationBarHidden(true)
                    .environmentObject(studentList)){
                    Text("Manage Users")
                        .padding(.leading, 25)
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                    
                    Image(systemName: "person")
                        .fontWeight(btnStyle.getFont())
                        .imageScale(.large)
                        .foregroundColor(btnStyle.getBtnFontColor())
                    
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBtnRadius())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                // create Connect Code button
                NavigationLink(destination: TeacherConnectCodeView()) {
                    Text("Connect Code")
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width: btnStyle.getWidth() + 35,
                               height: btnStyle.getHeight() + 5,
                               alignment: btnStyle.getAlignment())
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBtnRadius())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                // create Settings button
                Button(action:{withAnimation{showNextView = .teacherSettings}})
                {
                    Text("Settings")
                        .padding(.leading, 25)
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                    
                    Image(systemName: "gear")
                        .fontWeight(btnStyle.getFont())
                        .imageScale(.large)
                        .foregroundColor(btnStyle.getBtnFontColor())
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBtnRadius())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                
                
                // create Master Control button
                Button(action:{
                    withAnimation {
                        //show nextView .whateverViewYouWantToShow defined in ContentView Enum
                        showNextView = .teacherMasterControl}
                })
                {
                    Text("Master Control")
                        .padding(.leading, 25)
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width: btnStyle.getWidth() + 5,
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                    
                    Image(systemName: "lock")
                        .fontWeight(btnStyle.getFont())
                        .imageScale(.large)
                        .foregroundColor(btnStyle.getBtnFontColor())
                    
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBtnRadius())
                .cornerRadius(btnStyle.getBtnRadius())
                //.padding(.bottom, 100)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        //show nextView .whateverViewYouWantToShow defined in ContentView Enum
                        showNextView = .logout}
                }){
                    Text("Logout")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color.red)
                .cornerRadius(200)
            }
            .padding()
            .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
        }
    }
}

struct MainTeacherView_Previews: PreviewProvider {
        @State static private var showNextView: DisplayState = .mainTeacher

        static var previews: some View {
            TeacherMainView(showNextView: $showNextView)
        }

}
