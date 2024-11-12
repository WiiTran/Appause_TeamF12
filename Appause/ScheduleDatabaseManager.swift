//
//  ScheduleDatabaseManager.swift
//  Appause
//
//  Created by Rayanne Ohara on 10/24/24.
//
import FirebaseFirestore

class ScheduleDatabaseManager {
    static let shared = ScheduleDatabaseManager()

    // Loads a predefined permanent schedule based on its name (e.g., Regular, Thursday)
    func loadPermanentSchedule(_ scheduleName: String) -> [SchedulePeriod]? {
        switch scheduleName {
        case "Regular":
            return PermanentSchedules.regular
        case "Thursday":
            return PermanentSchedules.thursday
        case "Minimum Day":
            return PermanentSchedules.minimumDay
        case "Rally":
            return PermanentSchedules.rally
        case "Finals":
            return PermanentSchedules.finals
        default:
            return nil
        }
    }

    // Loads a custom schedule from Firestore by name
    func loadCustomSchedule(_ scheduleName: String, completion: @escaping ([SchedulePeriod]?) -> Void) {
        let db = Firestore.firestore()
        db.collection("schedules").document(scheduleName).getDocument { document, error in
            if let document = document, document.exists, let periodsData = document.data()?["periods"] as? [[String: String]] {
                let loadedPeriods: [SchedulePeriod] = periodsData.compactMap { data in
                    guard let name = data["name"], let startTime = data["startTime"], let endTime = data["endTime"] else { return nil }
                    return SchedulePeriod(name: name, startTime: startTime, endTime: endTime)
                }
                completion(loadedPeriods)
            } else {
                completion(nil)
            }
        }
    }

    // Saves a custom schedule to Firestore under the given name
    func saveCustomSchedule(_ scheduleName: String, periods: [SchedulePeriod]) {
        let db = Firestore.firestore()
        let periodData = periods.map { ["name": $0.name, "startTime": $0.startTime, "endTime": $0.endTime] }
        db.collection("schedules").document(scheduleName).setData(["periods": periodData]) { error in
            if let error = error {
                print("Error saving schedule: \(error.localizedDescription)")
            } else {
                print("Schedule saved successfully!")
            }
        }
    }
}
