//
//  StudentRequestView.swift
//
//
//  Created by user on 4/6/23.
//

import SwiftUI

struct StudentAppRequestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchAppName: String = ""
    var adminName = "Admin"
    @State var appList: RequestList
    
    var body: some View {
        VStack {
            Button(action: {dismiss()}) {
                
                
                Text("MAIN / REQUESTS / " + String(adminName).uppercased())
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
            
            Text("App Requests")
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
            
            List(appList.requests) {
                request in
                if(searchAppName.isEmpty ||
                    request.appName.contains(searchAppName)) {
                    AppRequestView(request: request)
                }
            }
            .overlay(RoundedRectangle(cornerRadius:10, style:.circular)
                .stroke(lineWidth:3))
            .frame(maxWidth: UIScreen.main.bounds.size.width*0.85,
                   maxHeight: UIScreen.main.bounds.size.height*0.7)
            
            Button(action: {
                //should open list of apps installed on phone
                //user selects one to add a new request to appList
                //currently just adds to appList to demonstrate UI functionality
                let newAppName = "App " + String(appList.requests.count)
                appList.requests.append(RequestData(appName: newAppName, approved: ApproveStatus.unprocessed))
            }) {
                Text("+ New")
                    .padding()
                    .fontWeight(btnStyle.getFont())
                    .background(btnStyle.getPathColor())
                    .foregroundColor(btnStyle.getPathFontColor())
                    .cornerRadius(25)
            }
            .padding(.top, 10)
        }
        .preferredColorScheme(btnStyle.getStudentScheme() == 0 ? .light : .dark)
    }
}

struct StudentAppRequestView_Previews: PreviewProvider {
    static var previews: some View {
        StudentAppRequestView(appList: defaultRequestArr())
    }
}
