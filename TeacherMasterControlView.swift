//
//  ContentView.swift
//  MasterControlPage
//
//  This tool enables the admin to temporarily override
//  any and all approved or denied request for registered user
//

import SwiftUI

struct TeacherMasterControlView: View {
    //Add this binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    
    @State private var status: String = "Normal"
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
            //make button show nextView .whateverViewYouWantToShow defined in ContentView Enum
                    showNextView = .mainTeacher}
            }){// Text displaying our current path
                Text("MAIN / MASTER CONTROL")
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
            
            //spacer to push button above it to the top. The higher the height value
            // the more it is pushed to the top. Lower closer to center
            //Spacer().frame(height:100)
            // Text displaying the current status of our app with normal meaning unlocked
            Text("Status: " + status)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .foregroundColor(Color("BlackWhite"))
                .padding(.top, 10)
                .padding(.bottom, 60)
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
            Spacer().frame(height:50)
            Button(action: {
                status = "Normal"
            }) {
                Text("Status Reset")
                    .padding()
                    .fontWeight(btnStyle.getFont())
                    .background(btnStyle.getPathColor())
                    .foregroundColor(btnStyle.getPathFontColor())
                    .cornerRadius(100)
            }
            .padding(.bottom, 250)
        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
}

struct TeacherMasterControlView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .teacherMasterControl
    
    static var previews: some View {
        TeacherMasterControlView(showNextView: $showNextView)
    }
    
}
