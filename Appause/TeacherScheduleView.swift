//
//  TeacherScheduleView.swift
//  Appause
//
//  Created by user on 9/17/24.
//

import SwiftUI

struct TeacherScheduleView: View {
    @State private var selectedSchedule = "Normal Schedule"
    @State private var schedules = ["Normal Schedule", "Finals Schedule", "Shortened Day", "Thursday Schedule", "Rallies"]
    @State private var periods = [
        "0 Period: Name",
        "1 Period: Name",
        "2 Period: Name",
        "3 Period: Name",
        "4 Period: Name"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Dropdown for selecting schedule
                Picker("Select Schedule", selection: $selectedSchedule) {
                    ForEach(schedules, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                // Display list of periods
                List {
                    ForEach(periods, id: \.self) { period in
                        Text(period)
                    }
                }
                
                // Add new class button
                NavigationLink(destination: TeacherScheduleCView()) {
                    Text("+ Add Class")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .navigationTitle("Class Schedule")
        }
    }
}

struct TeacherScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherScheduleView()
    }
}
