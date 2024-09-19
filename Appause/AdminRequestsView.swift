//
//  AdminRequestsView.swift
//  Appause
//
//  Created by Dash on 9/14/24
//

import SwiftUI

struct AppRequest: Identifiable {
    let id = UUID()
    let logo: String
    let name: String
    let dateTime: String
}

struct AdminRequestsView: View {
    @State private var searchText = ""
    
    // Sample data for app requests
    @State private var requests = [
        AppRequest(logo: "globe", name: "John Doe", dateTime: "03/15/2024 (10:30 AM)")
    ]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 16) {
                    Spacer().frame(height: 75)
                    
                    Text("App Requests")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    // Search bar
                    TextField("Search by name", text: $searchText)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    // App Requests list
                    List {
                        ForEach(filteredRequests) { request in
                            HStack {
                                // App logo (Temp logo)
                                Image(systemName: request.logo)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 10)
                                
                                VStack(alignment: .leading) {
                                    Text(request.name)
                                        .font(.headline)
                                    Text(request.dateTime)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                // Approve/deny buttons
                                HStack {
                                    Button(action: {
                                        // Approve action
                                    }) {
                                        Image(systemName: "hand.thumbsup")
                                            .foregroundColor(.green)
                                            .padding()
                                    }
                                    
                                    Button(action: {
                                        // Deny action
                                    }) {
                                        Image(systemName: "hand.thumbsdown")
                                            .foregroundColor(.red)
                                            .padding()
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                // "Menu" button
                Button(action: {
                    // Menu action
                }) {
                    Text("Menu")
                        .font(.headline)
                        .padding(16)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
                .background(Color.clear)
                .cornerRadius(20)
                .padding([.leading, .top], 16)
            }
        }
    }
    
    // Filtered requests based on search text
    var filteredRequests: [AppRequest] {
        if searchText.isEmpty {
            return requests
        } else {
            return requests.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct AdminRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        AdminRequestsView()
    }
}
