//
//  TeacherDeleteStudentView.swift
//  Project190
//
//  Created by Luis Campos on 4/19/23.
//

import SwiftUI
struct TeacherDeleteStudentView: View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var studentList: StudentList
    @Binding var stackingPermitted : String?
    @State var student: StudentData
    @State var firstButton = "MAIN / MANAGE USERS / DELETE STUDENT"
    @State var secondButton = "Yes"
    @State var thirdButton = "No"
    
    var body: some View{
        VStack{
            Button(action: {dismiss()}) {
                Text(firstButton)
                    .fontWeight(btnStyle.getFont())
                    .foregroundColor(btnStyle.getPathFontColor())
                    .frame(width: btnStyle.getWidth(),
                           height: btnStyle.getHeight() + 23,
                           alignment: btnStyle.getAlignment())
            }
            .padding()
            .background(btnStyle.getPathColor())
            .cornerRadius(btnStyle.getPathRadius())
            .padding(.top)
            Spacer()
            
            Text("Are you sure that you want to permanently delete this student from your list of registered users?").fontWeight(.bold).multilineTextAlignment(.center).frame(width:300, height:150, alignment:.center)
                .padding()
            HStack{
                Button(action:{
                    if let index = studentList.students.firstIndex(of: student) {
                        studentList.students.remove(at: index)
                    }
                    stackingPermitted = nil}){
                    //This button only works if TeacherManageUsers is a parent view.
                    //More specifically, this relies on the isActive value on a NavigationLink from a parent.
                    //Account for this if adding any views that could path into TeacherUserRequestView.
                    Text(secondButton)
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .frame(width:50)
                }
                .padding()
                .background(btnStyle.getBtnFontColor())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.trailing, 100)
                .padding(.bottom, 250)
                
                Button(action: {dismiss()}) {
                    Text(thirdButton)
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width:50)
                }
                .padding()
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 250)
            }
        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
}
struct TeacherDeleteStudentView_Previews: PreviewProvider{
    @StateObject var studentList = StudentList()
    static var previews: some View{
        let student = StudentData(name:"Don Joe", requests:defaultRequestArr())
        TeacherDeleteStudentView(stackingPermitted: .constant(nil), student: student)
            .environmentObject(StudentList())
    }
}
