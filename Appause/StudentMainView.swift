//
//  StudentMainView.swift
//  Appause
//  Created by Huy Tran on 4/16/24.



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
    @State var fifthButtonName = "Submitting Request"
    @State var sixthButtonName = "Register ClassID"
    @State var seventhButtonName = "Feedback"
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {}) {
                    Text("MAIN")
                        .foregroundColor(btnStyle.getPathFontColor())
                        .fontWeight(btnStyle.getFont())
                        .frame(width: btnStyle.getWidth(), height: btnStyle.getHeight(), alignment: btnStyle.getAlignment())
                }
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                
                Spacer()
                
                // Classes Button
                NavigationLink(destination: StudentConnectCodeView().navigationBarHidden(true)) {
                    HStack {
                        Text(secondButtonName)
                            .padding(.leading, 25)
                            .foregroundColor(btnStyle.getBtnFontColor())
                            .frame(width: btnStyle.getWidth(), height: btnStyle.getHeight(), alignment: btnStyle.getAlignment())
                            .fontWeight(btnStyle.getFont())
                        Image(systemName: "books.vertical")
                            .fontWeight(btnStyle.getFont())
                            .imageScale(.large)
                            .foregroundColor(btnStyle.getBtnFontColor())
                    }
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)

                // Connect Code Button
                NavigationLink(destination: StudentConnectCodeView().navigationBarHidden(true)) {
                    HStack {
                        Text(thirdButtonName)
                            .padding(.leading, 25)
                            .foregroundColor(btnStyle.getBtnFontColor())
                            .frame(width: btnStyle.getWidth(), height: btnStyle.getHeight(), alignment: btnStyle.getAlignment())
                            .fontWeight(btnStyle.getFont())
                        Image(systemName: "barcode")
                            .fontWeight(btnStyle.getFont())
                            .imageScale(.large)
                            .foregroundColor(btnStyle.getBtnFontColor())
                    }
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                // Settings Button
                Button(action: {
                    withAnimation { showNextView = .studentSettings }
                }) {
                    HStack {
                        Text(fourthButtonName)
                            .padding(.leading, 25)
                            .foregroundColor(btnStyle.getBtnFontColor())
                            .frame(width: btnStyle.getWidth(), height: btnStyle.getHeight(), alignment: btnStyle.getAlignment())
                            .fontWeight(btnStyle.getFont())
                        Image(systemName: "gear")
                            .imageScale(.large)
                            .foregroundColor(btnStyle.getBtnFontColor())
                    }
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())

                // Submitting Request Button
                Button(action: { withAnimation { showNextView = .UnblockRequest } }) {
                    HStack {
                        Text(fifthButtonName)
                            .padding(.leading, 25)
                            .foregroundColor(btnStyle.getBtnFontColor())
                            .frame(width: btnStyle.getWidth(), height: btnStyle.getHeight(), alignment: btnStyle.getAlignment())
                            .fontWeight(btnStyle.getFont())
                        Image(systemName: "hand.raised")
                            .fontWeight(btnStyle.getFont())
                            .imageScale(.large)
                            .foregroundColor(btnStyle.getBtnFontColor())
                    }
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                // Register ClassID Button
                NavigationLink(destination: registerClassView(showNextView: $showNextView).navigationBarHidden(true)) {
                    HStack {
                        Text(sixthButtonName)
                            .padding(.leading, 25)
                            .foregroundColor(btnStyle.getBtnFontColor())
                            .frame(width: btnStyle.getWidth(), height: btnStyle.getHeight(), alignment: btnStyle.getAlignment())
                            .fontWeight(btnStyle.getFont())
                        Image(systemName: "highlighter")
                            .fontWeight(btnStyle.getFont())
                            .imageScale(.large)
                            .foregroundColor(btnStyle.getBtnFontColor())
                    }
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                // Feedback Button
                NavigationLink(destination: FeedbackFormView().navigationBarHidden(true)) {
                    HStack {
                        Text(seventhButtonName)
                            .padding(.leading, 25)
                            .foregroundColor(btnStyle.getBtnFontColor())
                            .frame(width: btnStyle.getWidth(), height: btnStyle.getHeight(), alignment: btnStyle.getAlignment())
                            .fontWeight(btnStyle.getFont())
                        Image(systemName: "wallet.pass")
                            .fontWeight(btnStyle.getFont())
                            .imageScale(.large)
                            .foregroundColor(btnStyle.getBtnFontColor())
                    }
                }
                .padding()
                .background(btnStyle.getBtnColor())
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 10)
                
                Spacer()
                
                // Dark Mode Toggle
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding()
                
                Spacer()
                
                // Logout Button
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
        }
    }
}

struct StudentMainView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .mainStudent

    static var previews: some View {
        StudentMainView(showNextView: $showNextView)
    }
}
