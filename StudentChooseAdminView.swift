//
//  ContentView.swift
//
//
//  Created by user on 4/6/23.
//

import SwiftUI


struct StudentChooseAdminView: View {
    //Add this binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    
    var adminList:[String] = [
        "Admin 1",
        "Admin 2",
        "Admin 3"
    ]
    
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action:{
                    withAnimation {
                        //show nextView .whateverViewYouWantToShow defined in ContentView Enum
                    showNextView = .mainStudent}
                })
                {
                    Text("MAIN / CLASSES")
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                       
                }
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                .padding(.bottom, 70)
                
                ScrollView {
                    ForEach(adminList, id:\.self) { admin in
                        ZStack {
                            NavigationLink("-", destination: StudentDeleteAdminView(teacherName: admin)
                                .navigationBarHidden(true))
                                .font(.system(size:30))
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding(.leading, 5)
                                .foregroundColor(Color("BlackWhite"))
                            
                            Text(admin)
                                .font(.system(size:25))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth:.infinity, alignment:.center)
                                .foregroundColor(Color("BlackWhite"))
                            
                            NavigationLink(destination: StudentAppRequestView(adminName: admin, appList:  defaultRequestArr())
                                .navigationBarHidden(true)) {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(Color.yellow)
                            }
                                .padding(.trailing, 5)
                                .frame(maxWidth:.infinity, alignment:.trailing)
                                .font(.system(size:30))
                        }
                            .padding(5)
                    }
                    
                    NavigationLink(destination: StudentConnectCodeView()
                        .navigationBarHidden(true)) {
                        ZStack{
                            Text("+")
                                .font(.system(size:30))
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding(.leading, 5)
                            Text("New Class")
                                .frame(maxWidth:.infinity, alignment:.center)
                                .font(.system(size:25))
                        }
                            .padding(5)
                            .foregroundColor(Color("BlackWhite"))
                    }
                }
                .overlay(RoundedRectangle(cornerRadius:6, style:.circular)
                    .stroke(lineWidth:3))
                .frame(maxWidth: UIScreen.main.bounds.size.width*0.85,
                       maxHeight: UIScreen.main.bounds.size.height*0.7)
            }
        }
        .preferredColorScheme(btnStyle.getStudentScheme() == 0 ? .light : .dark)
    }
}

struct StudentChooseAdminView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .studentChooseAdmin

    static var previews: some View {
        StudentChooseAdminView(showNextView: $showNextView)
    }
}
