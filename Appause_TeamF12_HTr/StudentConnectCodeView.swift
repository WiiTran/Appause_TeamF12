//
//  ContentView.swift
//  Student Connect Code
//
//  Created by Rayanne Ohara 04/21/24
//  Purpose -------------------
//  Used to add classes for students
//-----------------------------
import SwiftUI

struct StudentConnectCodeView: View
{
    //Add this binding state for transitions from view to view
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @State private var connectCode: String = ""
    
    var body: some View {
        VStack {
            Text("Add Classes")
                .onTapGesture {withAnimation{self.presentationMode.wrappedValue.dismiss()}}
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 340,
                        height: 20,
                       alignment: .center)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
            .padding()
            .background(btnStyle.getPathColor())
            .cornerRadius(btnStyle.getPathRadius())
            .padding(.top)
            Spacer()
            
            Text("Connect Code")
                .font(.title)
                .padding(.top, 25)
            
            
            TextField("Insert Connect Code Here: ", text:$connectCode)
            .padding()
            .frame(width: 250.0, height: 100.0)
            .disabled(false)
            .textFieldStyle(.roundedBorder)
            
            Button("Submit Connect Code"){/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/}
                .padding()
                .fontWeight(.bold)
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(100)
            Spacer()
        }
        //.padding(.bottom, 400)
        .cornerRadius(100)
        .preferredColorScheme(btnStyle.getStudentScheme() == 0 ? .light : .dark)
    }
}

struct StudentConnectCodeView_Previews: PreviewProvider {
    static var previews: some View {
        StudentConnectCodeView()
    }
}
