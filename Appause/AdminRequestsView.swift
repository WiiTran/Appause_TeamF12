////
////  AdminRequestsView.swift
////  Appause
////
////  Created by Dash on 9/14/24
////
//
//import SwiftUI
//
//struct AppRequest: Identifiable {
//    let id = UUID()
//    let logo: String
//    let name: String
//    let dateTime: String
//}
//
//struct AdminRequestsView: View {
//    @State private var searchText = ""
//    
//    // Sample data for app requests
//    @State private var requestxqqs = [
//        AppRequest(logo: "Assets/google.png", name: "John Doe", dateTime: "03/15/2024 (10:30 AM)")
//    ]
//    
//    // States for controlling the popup and timer
//    @State private var showPopup = false
//    @State private var isTimerEnabled = false
//    @State private var hours = 0
//    @State private var minutes = 0
//    
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            VStack(spacing: 16) {
//                Spacer().frame(height: 75)
//                
//                Text("App Requests")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .frame(maxWidth: .infinity)
//                    .multilineTextAlignment(.center)
//                
//                // Search bar
//                TextField("Search by name", text: $searchText)
//                    .padding(10)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//                
//                // App Requests list
//                List {
//                    ForEach(filteredRequests) { request in
//                        HStack {
//                            // App logo (Temp logo)
//                            Image(systemName: request.logo)
//                                .resizable()
//                                .frame(width: 30, height: 30)
//                                .padding(.trailing, 10)
//                            
//                            VStack(alignment: .leading) {
//                                Text(request.name)
//                                    .font(.headline)
//                                Text(request.dateTime)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                            
//                            // Approve/deny buttons
//                            HStack {
//                                Button(action: {
//                                    withAnimation(.easeInOut(duration: 0.5)) {
//                                        showPopup = true
//                                    }
//                                }) {
//                                    Image(systemName: "hand.thumbsup")
//                                        .foregroundColor(.green)
//                                        .padding()
//                                }
//                                
//                                Button(action: {
//                                    // Deny action
//                                }) {
//                                    Image(systemName: "hand.thumbsdown")
//                                        .foregroundColor(.red)
//                                        .padding()
//                                }
//                            }
//                        }
//                    }
//                }
//                .listStyle(PlainListStyle())
//            }
//            
//            // Popup view for adding app request with timer options
//            if showPopup {
//                VStack(spacing: 20) {
//                    Text("Add App Request")
//                        .font(.title)
//                        .padding()
//                    
//                    Toggle("Set Timer", isOn: $isTimerEnabled)
//                        .padding()
//                    
//                    HStack {
//                        Text("Hours:")
//                        TextField("Hours", value: $hours, formatter: NumberFormatter())
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .frame(width: 50)
//                            .disabled(!isTimerEnabled)
//                            .foregroundColor(isTimerEnabled ? .black : .gray)
//                        
//                        Text("Minutes:")
//                        TextField("Minutes", value: $minutes, formatter: NumberFormatter())
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .frame(width: 50)
//                            .disabled(!isTimerEnabled)
//                            .foregroundColor(isTimerEnabled ? .black : .gray)
//                    }
//                    .padding()
//                    
//                    HStack {
//                        Button("Add App") {
//                            // Add app logic with or without timer
//                            if isTimerEnabled {
//                                startTimer(hours: hours, minutes: minutes)
//                            }
//                            withAnimation {
//                                showPopup = false
//                            }
//                        }
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                        
//                        Button("Cancel") {
//                            withAnimation {
//                                showPopup = false
//                            }
//                        }
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                    }
//                }
//                .frame(width: 400, height: 500)
//                .background(Color.white)
//                .cornerRadius(20)
//                .shadow(radius: 10)
//                .transition(.move(edge: .bottom))
//                .offset(y: showPopup ? 0 : UIScreen.main.bounds.height)
//                .animation(.easeInOut(duration: 0.5), value: showPopup)
//            }
//            
//            // "Menu" button
//            Button(action: {
//                // Menu action
//            }) {
//                Text("Menu")
//                    .font(.headline)
//                    .padding(16)
//                    .foregroundColor(.black)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.black, lineWidth: 2)
//                    )
//            }
//            .background(Color.clear)
//            .cornerRadius(20)
//            .padding([.leading, .top], 16)
//        }
//    }
//    
//    // Filtered requests based on search text
//    var filteredRequests: [AppRequest] {
//        if searchText.isEmpty {
//            return requests
//        } else {
//            return requests.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//        }
//    }
//    
//    // Timer logic for app deletion
//    func startTimer(hours: Int, minutes: Int) {
//        let totalSeconds = (hours * 3600) + (minutes * 60)
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(totalSeconds)) {
//            // Code to remove the app from the list
//            requests.removeAll() // Replace this with specific logic for app removal
//        }
//    }
//}
//
//struct AdminRequestsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminRequestsView()
//    }
//}
