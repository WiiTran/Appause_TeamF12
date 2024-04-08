//
//  TeacherAllRequestsView.swift
//  Project190
//
//  Created by UserSSD on 10/13/23.
//

import SwiftUI

struct TeacherAllRequestsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var studentList: StudentList
    @State private var searchAppName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {dismiss()}) {
                        Text("MAIN / REQUESTS")
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
                
                List {
                    ForEach(studentList.students) {
                        student in
                        ForEach(student.requestObject.requests) {
                            request in
                            if(searchAppName.isEmpty || request.appName.contains(searchAppName)) {
                                unprocessedRequest(request: request, studentName: student.name, searchAppName: searchAppName)
                            }
                        }
                    }
                }
                .overlay(RoundedRectangle(cornerRadius:10, style:.circular)
                    .stroke(lineWidth:3))
                .frame(maxWidth: UIScreen.main.bounds.size.width*0.85,
                       maxHeight: UIScreen.main.bounds.size.height*0.7)
            }
        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
}

struct unprocessedRequest: View {
    //This view is required to allow processed requests to be automatically removed from the list without refreshing the entire view.
    //This is due to the nature of nested observable objects in Swift.
    //For the view to detect a change to RequestData, RequestData must be the ObservedObject.
    //But RequestData  is nested inside StudentData, and thus cannot be observed by TeachersAllRequestsView.
    //By providing the RequestData to unprocessedRequest, it can be observed.
    @ObservedObject var request: RequestData
    @State var studentName: String
    @State var searchAppName: String
    
    var body: some View {
        if(request.approved == ApproveStatus.unprocessed) {
            TeacherAppView(request: request, studentName: studentName, parentNavText: "REQUESTS / ")
        }
    }
}

struct TeacherAllRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherAllRequestsView(studentList: StudentList())
            .environmentObject(StudentList())
    }
}
