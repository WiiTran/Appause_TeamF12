//
//  ClassList.swift
//  Appause
//
//  Created by Tran Chi on 10/1/24.
import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Class: Codable, Identifiable {
    var id: UUID // or var id: String/Int
    var className: String
    var TeacherID: String
    var Name: String
    // Initializer
    init(className: String, TeacherID: String, Name: String) {
        self.id = UUID() // Generate a new UUID
        self.className = className
        self.TeacherID = TeacherID
        self.Name = Name
    }
}
struct Teacher: Identifiable, Codable {
        @DocumentID var id: String?
        var Name: String
}






