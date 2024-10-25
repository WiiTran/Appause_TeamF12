//
//  ClassSearchView.swift
//  Appause
//  Created by Andy Pham on 10/15/24.
//
import SwiftUI

struct ClassSearchView: View {
    
    @State private var searchText = ""
    @State private var SearchID = ""
    
    var body: some View {
        VStack {
            Text("Class Search")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
            TextField("Search Class", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        Spacer()
                    }
                ).padding(.horizontal)
                .padding(.top)
            
            Button(action: {
                // Action to perform when the button is pressed
                SearchID = "Search By ID and Time!"
            }) {
                Text("Search")
                    .font(.title)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
    

struct ClassSearchView_Previews:PreviewProvider {
    static var previews:some View{
        ClassSearchView()
    }
}

