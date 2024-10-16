//
//  TeacherMainView.swift
//  Appause
//
//  Created by Huy Tran on 4/16/24.
//  Revised by Rayanne Ohara on 09/12/2024
//  Revised by Rayanne Ohara on 10/01/2024
//  Revised by Rayanne Ohara on 10/14/2024
//
import SwiftUI
import FirebaseFirestore

struct TeacherMainView: View {
    // Binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    @StateObject var studentList = StudentList()
    
    // States for Master Control
    @State private var status: String = "Normal"
    @State private var currentSchedule: String = "Normal Schedule" // Track the active schedule
    @State private var activePeriods: [(classID: String, startTime: Date, endTime: Date)] = [] // Active periods from the selected schedule
    @State private var isOverrideActive: Bool = false // Track whether the manual override is active

    var body: some View {
        // Main tab
        TabView {
            VStack {
                Button(action: {
                    withAnimation {
                        // Transition to the next view
                        showNextView = .mainTeacher
                    }
                }) {
                    Text("MAIN")
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
                
                // Text displaying the current status of the app
                Text("Status: " + status)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .foregroundColor(Color("BlackWhite"))
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 105)

                // Lock/Unlock buttons
                HStack {
                    // Disable buttons based on the current schedule
                    if isOverrideActive {
                        VStack {
                            Button(action: {
                                status = "Locked"
                            }, label: {
                                Image(systemName: "lock")
                                    .padding(.trailing)
                                    .font(.system(size: 100))
                                    .foregroundColor(.red)
                            })
                            Text("Lock")
                                .padding(.trailing)
                        }
                        VStack {
                            Button(action: {
                                status = "Unlocked"
                            }, label: {
                                Image(systemName: "lock.open")
                                    .padding(.leading)
                                    .font(.system(size: 100))
                                    .foregroundColor(.green)
                            })
                            Text("Unlock")
                        }
                    } else {
                        // Show a single button based on the status from the schedule
                        if let currentPeriod = activePeriods.first(where: { $0.startTime <= Date() && $0.endTime >= Date() }) {
                            // If within current period, show locked status
                            Text("Status: Locked")
                                .font(.title)
                                .foregroundColor(.red)
                        } else {
                            // If not within any period, show unlocked status
                            Text("Status: Unlocked")
                                .font(.title)
                                .foregroundColor(.green)
                        }
                    }
                }
                Spacer().frame(height: 25)

                // Display connected users
                VStack {
                    Text("Connected Users")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        VStack {
                            ForEach(studentList.students) { student in
                                HStack {
                                    Text(student.name)
                                        .font(.callout)
                                        .foregroundColor(btnStyle.getBtnFontColor())
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(0)
                                .padding(.horizontal)
                            }
                        }
                    }
                }

                Spacer()

                // Switch for overriding lock/unlock status
                Toggle("Manual Override", isOn: $isOverrideActive)
                    .padding()
                    .onChange(of: isOverrideActive) { value in
                        // Reset the status when toggle is switched
                        if !value {
                            status = "Normal" // Reset to normal when override is turned off
                        }
                    }
            }
            .onAppear {
                loadActiveSchedule()
            }
            .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            // Other views
            TeacherAllRequestsView(studentList: studentList)
                .tabItem {
                    Image(systemName: "hand.raised")
                    Text("Requests")
                }
            TeacherWhitelist()
                .tabItem {
                    Image(systemName: "bookmark.slash")
                    Text("WhiteList")
                }
            TeacherManageUsers()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Students")
                }
                .environmentObject(studentList)
            TeacherScheduleView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Schedule")
                }
            TeacherSettingsView(showNextView: $showNextView)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }

    // Load the active schedule's periods
    func loadActiveSchedule() {
        let db = Firestore.firestore()
        db.collection("schedules").document(currentSchedule).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                if let periodsData = data?["periods"] as? [[String: Any]] {
                    activePeriods = periodsData.compactMap { periodDict in
                        guard let classID = periodDict["classID"] as? String,
                              let startTime = periodDict["startTime"] as? Timestamp,
                              let endTime = periodDict["endTime"] as? Timestamp else { return nil }
                        return (classID, startTime.dateValue(), endTime.dateValue())
                    }
                }
            } else {
                print("Error loading active schedule: \(error?.localizedDescription ?? "Unknown error")")
                // Optionally handle error or set default active periods
            }
        }
    }

    // Date formatter for displaying time
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Format time as "hh:mm AM/PM"
        return formatter.string(from: date)
    }
}

struct TeacherMainView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .mainTeacher
    
    static var previews: some View {
        TeacherMainView(showNextView: $showNextView)
    }
}
