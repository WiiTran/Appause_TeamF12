//
//  TeacherMainView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//  Revised by Rayanne Ohara on 09/12/2024
//  Revised by Rayanne Ohara on 10/01/2024
//

import SwiftUI

struct TeacherMainView: View {
    // Add this binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    @StateObject var studentList = StudentList()
    @State var studentName = ""
    // States for Master Control
    @State private var status: String = "Normal"
    
    // States for Connect Code Generation
    @State private var generatedCode: String = ""
    // Array used to generate a random character string
    @State private var charList = ["1","2","3","4","5","6","7","8","9","0",
                    "a","b","c","d","e","f","g","h","i","j",
                    "k","l","m","n","o","p","q","r","s","t",
                    "u","v","w","x","y","z"]
    
    var body: some View {
        
        // Main tab
        TabView {
            VStack {
                Button(action: {
                    withAnimation {
                        // Make button show nextView .whateverViewYouWantToShow defined in ContentView Enum
                        showNextView = .mainTeacher
                    }
                }) {
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
                .padding(.top)
                Spacer()
                
                // Text displaying the current status of our app with normal meaning unlocked
                Text("Status: " + status)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .foregroundColor(Color("BlackWhite"))
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 105)
                    
                // Had to use HStack to align buttons horizontally
                HStack {
                    VStack {
                        // Clicking on this button locks all apps from a student's phone
                        Button(action: {
                            status = "Locked"
                        }, label: {
                            Image(systemName: "lock")
                                .padding(.trailing)
                                .font(.system(size: 100))
                                .foregroundColor(.red)
                        })
                        Text("Lock")
                            .padding(.trailing)
                    }
                    VStack {
                        // Clicking on this button unlocks all apps from a student's phone
                        Button(action: {
                            status = "Unlocked"
                        }, label: {
                            Image(systemName: "lock.open")
                                .padding(.leading)
                                .font(.system(size: 100))
                                .foregroundColor(.green)
                        })
                        Text("Unlock")
                    }
                }
                Spacer().frame(height: 25)
                
                Text("Connect Code")
                    .font(.title)
                    .padding(1)
                TextField("Press the button to generate a code", text: $generatedCode)
                    .background(Color.white.opacity(0.25))
                    .foregroundColor(Color("BlackWhite"))
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1))
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
                    .padding(5)
                // Generates a random string of 6 characters using characters from the charList array
                Button(action: {
                    generatedCode = ""
                    for _ in 0..<6 {
                        let randomNum = Int.random(in: 0..<36)
                        generatedCode += charList[randomNum]
                    }
                }) {
                    Text("Generate New Code")
                        .padding()
                        .fontWeight(btnStyle.getFont())
                        .background(btnStyle.getPathColor())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .cornerRadius(100)
                }
                .padding(.bottom, 25)
                
                // UserList
                VStack {
                    Text("Users")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        VStack {
                            ForEach(studentList.students) { student in
                                HStack {
                                    Text(student.name)
                                        .font(.callout)
                                        .foregroundColor(btnStyle.getBtnFontColor())
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(0)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            // TeacherAllRequestsView
            TeacherAllRequestsView()
                .tabItem {
                    Image(systemName: "hand.raised")
                    Text("Requests")
                }
            TeacherWhitelist()
                .tabItem {
                    Image(systemName: "bookmark.slash")
                    Text("WhiteList")
                }
            TeacherManageUsers()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Students")
                }
                .environmentObject(studentList)
            TeacherScheduleView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Schedule")
                }
            TeacherSettingsView(showNextView: $showNextView)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct MainTeacherView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .mainTeacher
    
    static var previews: some View {
        TeacherMainView(showNextView: $showNextView)
    }
}
