//
//  TeacherWhitelist.swift
//
//  Created by Nav Bernal on 9/28/23
//


import SwiftUI


struct TeacherWhitelistApp: View {
    @State var request: RequestData
    @State var studentName: String
   
    var body: some View {
        ZStack {
            Image(systemName:"phone.circle.fill")
                .frame(maxWidth:.infinity, alignment:.leading)
                .foregroundColor(.green)
            
            NavigationLink(destination: TeacherAppDescription(appData: request)
                .navigationBarHidden(true)) {
                Text(request.appName)
                    .frame(maxWidth:.infinity, alignment:.center)
            }
                
            //Text(request.appName)
                //.frame(maxWidth:.infinity, alignment:.center)
            HStack {
                Button(action:{ //Approve
                    request = RequestData(appName: request.appName, approved: ApproveStatus.approved)
                }) {
                    if(request.approved == ApproveStatus.approved) {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(.green)
                    }
                    else {
                        Image(systemName: "hand.thumbsup")
                            .foregroundColor(.green)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Button(action:{ //Deny
                    request = RequestData(appName: request.appName, approved: ApproveStatus.denied)
                }) {
                    if(request.approved == ApproveStatus.denied) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundColor(.red)
                    }
                    else {
                        Image(systemName: "hand.thumbsdown")
                            .foregroundColor(.red)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .frame(maxWidth:.infinity, alignment:.trailing)
        }
    }
}

//ApproveStatus and RequestData defined in StudentAppRequestView

struct TeacherWhitelist: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchAppName: String = ""
    var userName = "User"
    
    @State var appList:[RequestData] = [
        RequestData(appName: "Phone", approved: ApproveStatus.approved)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {dismiss()}) {
                        Text("MAIN / WHITELIST")
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
                
                Text("Whitelisted Apps")
                    .padding(.top, 50)
                    .padding(.bottom, 5)
                TextField(
                    "Search",
                    text: $searchAppName
                )
                .multilineTextAlignment(.center)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth:1))
                .frame(maxWidth: UIScreen.main.bounds.size.width*0.75)
                
                List {
                    ForEach(appList) { request in
                        if(searchAppName.isEmpty ||
                           request.appName.contains(searchAppName)) {
                            TeacherWhitelistApp(request: request, studentName: userName)
                        }
                    }
                }
                .overlay(RoundedRectangle(cornerRadius:10, style:.circular)
                    .stroke(lineWidth:3))
                .frame(maxWidth: UIScreen.main.bounds.size.width*0.85,
                       maxHeight: UIScreen.main.bounds.size.height*0.7)
                
                Button(action: {
                    //should open list of apps installed on phone
                    //currently just adds to appList to demonstrate UI functionality
                    let newAppName = "App " + String(appList.count)
                    appList.append(RequestData(appName: newAppName, approved: ApproveStatus.unprocessed))
                }) {
                    Text("+ New")
                        .padding()
                        .fontWeight(btnStyle.getFont())
                        .background(btnStyle.getPathColor())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .cornerRadius(25)
                }
                .padding(.top, 10)
            }        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
}

struct TeacherWhitelist_Previews: PreviewProvider {
    static var previews: some View {
        TeacherWhitelist()
    }
}

