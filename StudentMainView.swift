//
//  StudentMainView.swift
//
//  Created by Luis Campos on 4/6/23.
//  Modified by Nav Bernal and Alec Lobato on 4/20/23.
//

import SwiftUI

struct StudentMainView: View {
    //Add this binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    
    @State var mainButtonColor = Color.black
    @State private var btnColor: Color = Color.gray.opacity(0.25)
    @State private var cornerRadius: CGFloat = 6
    @State private var frameWidth: CGFloat = 300
    @State private var frameHeight: CGFloat = 20
    
    @State var secondButtonName = "Classes"
    @State var thirdButtonName = "Connect Code"
    @State var fourthButtonName = "Settings"
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action:{}){
                    Text("MAIN")
                        .foregroundColor(btnStyle.getPathFontColor())
                        .fontWeight(btnStyle.getFont())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                }
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                Spacer()
                // When pressed, will allow students to view and manage all of their classes
                Button(action:{withAnimation
                    {showNextView = .studentChooseAdmin}
                }){
                    Text(secondButtonName)
                        .padding(.leading, 25)
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width:btnStyle.getWidth(),
                               height:btnStyle.getHeight(),
                               alignment:btnStyle.getAlignment())
                        .fontWeight(btnStyle.getFont())
                    Image(systemName: "hand.raised")
                        .fontWeight(btnStyle.getFont())
                        .imageScale(.large)
                        .foregroundColor(btnStyle.getBtnFontColor())
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                
                NavigationLink(destination:StudentConnectCodeView()
                    .navigationBarHidden(true)){
                        Text(thirdButtonName)
                            .padding(.leading, 25)
                            .foregroundColor(btnStyle.getBtnFontColor())
                            .frame(width:btnStyle.getWidth() + 35,
                                   height:btnStyle.getHeight(),
                                   alignment:btnStyle.getAlignment())
                            .fontWeight(btnStyle.getFont())
                    }
                    .padding()
                    .background(btnStyle.getBtnColor())
                    .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                    .cornerRadius(btnStyle.getBtnRadius())
                    .padding(.bottom, 10)
                
                Button(action: {withAnimation {showNextView = .studentSettings}}){
                    Text(fourthButtonName)
                        .padding(.leading, 25)
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width:btnStyle.getWidth(),
                               height:btnStyle.getHeight(),
                               alignment:btnStyle.getAlignment())
                        .fontWeight(btnStyle.getFont())
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundColor(btnStyle.getBtnFontColor())
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                //.padding(.bottom, 335)
                Spacer()
                // When pressed, will take the student back to the main login page
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
