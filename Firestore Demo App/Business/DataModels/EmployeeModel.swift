//
//  EmployeeModel.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import Foundation
import FirebaseFirestore

struct EmployeeModel: Codable {
    
    var documentId: String
    var name: String
    var team: String
    var email: String
    var joinedAs: String
    var contact: String
    
    private enum CodingKeys: String, CodingKey {
        case documentId = "document_id"
        case name, team, email, contact
        case joinedAs = "joined_as"
    }
    
    func getDataDictionary() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "team": team,
            "joined_as": joinedAs,
            "contact": contact
        ]
    }
}
