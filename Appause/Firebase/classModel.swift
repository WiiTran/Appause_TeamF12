

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

struct studentClass: Codable, Identifiable {
    var id: String {classID}
    var classID: String// or var id: String/Int
    var className: String
    var teacherID: String
    var Name: String
    var classTime = Date()
    var days: [String]
    // Initializer
    init(classID: String, className: String, teacherID: String, Name: String, classTime: Date, days: [String]) {
        self.classID = classID
        self.className = className
        self.teacherID = teacherID
        self.Name = Name
        self.classTime = classTime
        self.days = days
        
        
    }
}
struct Teacher: Identifiable, Codable {
        @DocumentID var id: String?
        var Name: String
        var teacherID : String
}

