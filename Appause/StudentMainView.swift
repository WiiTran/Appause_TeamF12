//
//  StudentMainView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/16/24.
//


import SwiftUI

struct StudentMainView: View {
    // Binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = false

    // Track dark mode preference with AppStorage
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @State var mainButtonColor = Color.black
    @State private var btnColor: Color = Color.gray.opacity(0.25)
    @State private var cornerRadius: CGFloat = 6
    @State private var frameWidth: CGFloat = 300
    @State private var frameHeight: CGFloat = 20
    
    @State var secondButtonName = "Classes"
    @State var thirdButtonName = "Connect Code"
    @State var fourthButtonName = "Settings"
    @State var fifthButtonName = "Submiting Request"
    @State var sixthButtonName = "Register ClassID"
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
                
                Button(action: {
                    withAnimation { showNextView = .enrolledClass }
                }) {
                    Text(secondButtonName)
                        .padding(.leading, 25)
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
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
                
                NavigationLink(destination: StudentConnectCodeView()
                    .navigationBarHidden(true)) {
                        Text(thirdButtonName)
                            .padding(.leading, 25)
                            .foregroundColor(btnStyle.getBtnFontColor())
                            .frame(width: btnStyle.getWidth() + 35,
                                   height: btnStyle.getHeight(),
                                   alignment: btnStyle.getAlignment())
                            .fontWeight(btnStyle.getFont())
                    }
                    .padding()
                    .background(btnStyle.getBtnColor())
                    .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                    .cornerRadius(btnStyle.getBtnRadius())
                    .padding(.bottom, 10)
                
                Button(action: {
                    withAnimation { showNextView = .studentSettings }
                }) {
                    Text(fourthButtonName)
                        .padding(.leading, 25)
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                        .fontWeight(btnStyle.getFont())
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundColor(btnStyle.getBtnFontColor())
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                
                Button(action:{withAnimation
                    {showNextView = .UnblockRequest
                    }}){
                    Text(fifthButtonName)
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
                
                NavigationLink(destination:registerClassView(showNextView: $showNextView)
                    .navigationBarHidden(true)){
                        Text(sixthButtonName)
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
                //.padding(.bottom, 335)
                Spacer()
                
                // Dark Mode Toggle
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isUserLoggedIn = false
                        showNextView = .logout
                    }
                }) {
                    Text("Logout")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color.red)
                .cornerRadius(200)
            }
            .padding()
            .preferredColorScheme(isDarkMode ? .dark : .light)
        } // updated
    }
}

struct StudentMainView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .mainStudent

    static var previews: some View {
        StudentMainView(showNextView: $showNextView)
    }
}
