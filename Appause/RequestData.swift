//
//  RequestData.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/23/24.
//

import Foundation
import SwiftUI

enum ApproveStatus {
    case approved
    case approvedTemporary
    case denied
    case unprocessed
}

class RequestData: Hashable, Identifiable, ObservableObject {
    let id = UUID()
    var documentID: String  // Added documentID to store Firestore document ID
    var appName: String
    var appDescription: String
    @Published var approved: ApproveStatus
    @Published var approvedDuration: Float
    
    init(documentID: String, appName: String, approved: ApproveStatus) {
        self.documentID = documentID  // Assigning Firestore document ID
        self.appName = appName
        self.approved = approved
        self.appDescription = "Generic App Description"
        self.approvedDuration = .infinity
    }
    // New initializer to create RequestData from a Request object
        init(from request: Request) {
           
            self.documentID = request.documentID  // Initialize documentID from the Request object
            self.appName = request.appName
            self.appDescription = "Generic App Description"
            self.approvedDuration = .infinity

            // Map the status string to the ApproveStatus enum
            switch request.status {
                case "approved":
                    self.approved = .approved
                case "approvedTemporary":
                    self.approved = .approvedTemporary
                case "denied":
                    self.approved = .denied
                default:
                    self.approved = .unprocessed
            }
        }
    

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(appName)
    }
}

extension RequestData: Equatable {
    static func == (lhs: RequestData, rhs: RequestData) -> Bool {
        return lhs.id == rhs.id
    }
}

class StudentData: Hashable, Identifiable, ObservableObject {
    let id = UUID() //Required for Identifiable
    var name: String
    @Published var requestObject: RequestList
    
    init(name:String, requests:RequestList) {
        self.name = name
        self.requestObject = requests
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension StudentData: Equatable {
    static func == (lhs: StudentData, rhs: StudentData) -> Bool {
        return lhs.name == rhs.name &&
        lhs.requestObject == rhs.requestObject &&
        lhs.id == rhs.id
    }
}

class StudentList: ObservableObject {
    @Published var students = [
        StudentData(name: "John Doe", requests: defaultRequestArr()),
        StudentData(name: "John Jackson", requests: defaultRequestArr()),
        StudentData(name: "Danny Devito", requests: defaultRequestArr()),
        StudentData(name: "Taylor Newall", requests: defaultRequestArr()),
        StudentData(name: "Xavier Desmond", requests: defaultRequestArr()),
        StudentData(name: "Ronald McDonald", requests: defaultRequestArr())]
}

struct RequestList: Hashable {
    var requests: [RequestData] = []
    
    init(requests:[RequestData]) {
        self.requests = requests
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(requests)
    }
}

extension RequestList: Equatable {
    static func == (lhs: RequestList, rhs: RequestList) -> Bool {
        return lhs.requests == rhs.requests
    }
}

func defaultRequestArr() -> RequestList {
    return RequestList(requests: [ // Used for convenience.
        RequestData(documentID: "testID1", appName: "Unprocessed Request", approved: ApproveStatus.unprocessed),
        RequestData(documentID: "testID2", appName: "Approved App", approved: ApproveStatus.approved),
        RequestData(documentID: "testID3", appName: "Temporarily Approved App", approved: ApproveStatus.approvedTemporary),
        RequestData(documentID: "testID4", appName: "Denied App", approved: ApproveStatus.denied)
    ])
}

struct AppThumb: View {
    @ObservedObject var requestData: RequestData
    
    var body : some View {
        switch requestData.approved {
        case .approved:
            Image(systemName: "hand.thumbsup.fill")
                .foregroundColor(.green)
        case .approvedTemporary:
            Image(systemName: "hand.thumbsup.fill")
                .foregroundColor(.yellow)
        case .denied:
            Image(systemName: "hand.thumbsdown.fill")
                .foregroundColor(.red)
        case .unprocessed:
            Image(systemName: "hand.thumbsup")
                .foregroundColor(.gray)
        }
    }
}

//View that displays data for a single request.
struct AppRequestView: View {
    @ObservedObject var request: RequestData
    var body: some View {
        ZStack {
            Image(systemName:"applelogo")
                .frame(maxWidth:.infinity, alignment:.leading)
            Text(request.appName)
                .frame(maxWidth:.infinity, alignment:.center)
            AppThumb(requestData: request)
            .frame(maxWidth:.infinity, alignment:.trailing)
        }
    }
}

struct Class {
    var name: String
    var period: String
}
