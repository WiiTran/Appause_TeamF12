//
//  ScheduleDatabaseManager.swift
//  Appause
//
//  Created by Rayanne Ohara on 10/24/24.
//

import Foundation
import FirebaseFirestore

class ScheduleDatabaseManager {
    static let shared = ScheduleDatabaseManager()
    private let db = Firestore.firestore()

    private init() {}

    func loadPermanentSchedule(_ scheduleName: String) -> [Period] {
        return PermanentSchedules.getSchedule(scheduleName) ?? []
    }

    func loadCustomSchedule(_ scheduleName: String, completion: @escaping ([Period]?) -> Void) {
        db.collection("schedules").document(scheduleName).getDocument { document, error in
            if let document = document, document.exists, let data = document.data(),
               let periodsData = data["periods"] as? [[String: Any]] {
                let periods = periodsData.compactMap { periodDict -> Period? in
                    guard let id = periodDict["id"] as? Int,
                          let name = periodDict["classID"] as? String,
                          let startTime = periodDict["startTime"] as? Timestamp,
                          let endTime = periodDict["endTime"] as? Timestamp else { return nil }
                    return Period(id: id, name: name, startTime: startTime.dateValue().description, endTime: endTime.dateValue().description)
                }
                completion(periods)
            } else {
                print("Error loading schedule: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }

    func saveSchedule(_ scheduleName: String, periods: [Period], isPermanent: Bool) {
        guard !isPermanent else { return }
        
        let periodData: [[String: Any]] = periods.map { period in
            [
                "id": period.id,
                "classID": period.name,
                "startTime": Timestamp(date: DateFormatter.localizedString(from: period.startTime, dateStyle: .none, timeStyle: .short)),
                "endTime": Timestamp(date: DateFormatter.localizedString(from: period.endTime, dateStyle: .none, timeStyle: .short))
            ]
        }

        db.collection("schedules").document(scheduleName).setData([
            "periods": periodData,
            "name": scheduleName
        ]) { error in
            if let error = error {
                print("Error saving schedule: \(error.localizedDescription)")
            } else {
                print("Schedule saved successfully!")
            }
        }
    }
}
