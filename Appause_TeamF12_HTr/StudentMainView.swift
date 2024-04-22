//
//  StudentMainView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//  Edited by Rayanne Ohara 04/21/24
//  Purpose -------------------
//  Main page of the student view
//-----------------------------
import SwiftUI

struct StudentMainView: View {
    @Binding var showNextView: DisplayState
    
    @State var mainButtonColor = Color.black
    @State private var btnColor: Color = Color.gray.opacity(0.25)
    @State private var cornerRadius: CGFloat = 6
    @State private var frameWidth: CGFloat = 300
    @State private var frameHeight: CGFloat = 20
    @State var secondButtonName = "Manage Classes"
    @State var fourthButtonName = "Setting"
    
    let apps = ["Call", "Message", "Facebook"]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            showNextView = .login
                        }
                    }){
                        Text("Logout")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(200)
                    }
                    Spacer()
                }
                Spacer()
                Text("Student Home Page")
                    .fontWeight(.bold)
                    .font(.system(size: 35))
                    .padding(.bottom, 45)
                Spacer()
                // When pressed, will allow students to view and manage all of their classes
                Button(action:{withAnimation
                    {showNextView = .studentChooseAdmin}
                }){
                    Text(secondButtonName)
                        .padding(.leading, 25)
                        .foregroundColor(.black)
                        .frame(width:300,
                               height: 20,
                               alignment:.center)
                        .fontWeight(.bold)
                    Image(systemName: "hand.raised")
                        .fontWeight(.bold)
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
                .padding()
                .background(.white)
                .border(.black, width: 5)
                .cornerRadius(10)
                .padding(.bottom, 10)
                
                Button(action: {withAnimation {showNextView = .studentSettings}}){
                    Text(fourthButtonName)
                        .padding(.leading, 25)
                        .foregroundColor(.black)
                        .frame(width:300,
                               height: 20,
                               alignment:.center)
                        .fontWeight(.bold)
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
                .padding()
                .background(.white)
                .border(.black, width: 5)
                .cornerRadius(10)
                //.padding(.bottom, 335
                Spacer()
                List(apps, id: \.self) {app in Text(app)}
                    .listStyle(PlainListStyle())
                    .padding(.top)
                Spacer()
                // When pressed, will take the student back to the main login page
                Button(action: {
                    withAnimation {
                        //show nextView .whateverViewYouWantToShow defined in ContentView Enum
                        showNextView = .studentConnectCode}
                }){
                    Text("Add Classes")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color.gray)
                .cornerRadius(200)
            }
            .padding()
            .preferredColorScheme(btnStyle.getStudentScheme() == 0 ? .light : .dark)
        }
    }
}

struct StudentMainView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .mainStudent

    static var previews: some View {
        StudentMainView(showNextView: $showNextView)
    }
}
