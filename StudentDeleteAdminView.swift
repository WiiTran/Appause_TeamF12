//
//  StudentDeleteAdminView.swift
//  Project190
//
//  Created by Luis Campos on 4/19/23.
//

import SwiftUI
struct StudentDeleteAdminView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var firstButton = "MAIN / CLASSES / REMOVE CLASS"
    @State var secondButton = "YES"
    @State var thirdButton = "NO"
    @State var mainButtonColor = Color.black
    
    var teacherName = "Mr. Brimberry"
    
    var body: some View {
        VStack{
            Button(action:{dismiss()}){
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
            
            Text("Are you sure that you want to request that " + teacherName + " removes you from their class?").fontWeight(.bold).multilineTextAlignment(.center).frame(width:300, height:150, alignment:.center)
                .padding()
            HStack{
                Button(action:{ dismiss()}){
                    Text(secondButton).fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .frame(width:50)
                }
                .padding()
                .background(btnStyle.getBtnFontColor())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.trailing, 100)
                .padding(.bottom, 250)
                
                Button(action:{ dismiss()}){
                    Text(thirdButton).fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getBtnFontColor())
                        .frame(width:50)
                }
                .padding()
                .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
                .cornerRadius(btnStyle.getBtnRadius())
                .padding(.bottom, 250)
            }
        }
        .preferredColorScheme(btnStyle.getStudentScheme() == 0 ? .light : .dark)
    }
}
struct StudentDeleteAdminView_Previews: PreviewProvider{
    //@State static private var showNextView: DisplayState = .studentDeleteAdmin
    static var previews: some View{
        StudentDeleteAdminView()
    }
}
