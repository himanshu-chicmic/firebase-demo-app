//
//  FirestoreManager.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import FirebaseFirestore

class FirestoreManager {
    
    // shared instance of FirestoreManager
    static let shared = FirestoreManager()
    // instance for firestore
    private let db = Firestore.firestore()
    
    // array to store employee list
    private var employeeList: [[String: Any]] = []
    
    // getter propetry for employee list
    var getEmployeeList: [EmployeeModel] {
        get {
            var list: [EmployeeModel] = []
            for data in employeeList {
                let encodeData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                if let encodeData {
                    do {
                        let decode = try JSONDecoder().decode(EmployeeModel.self, from: encodeData)
                        list.append(decode)
                    } catch {
                        print(error)
                    }
                }
            }
            return list
        }
    }
    
    // MARK: - methods
    
    // get data once
    func readData(completion: @escaping (Bool) -> Void) {
        db.collection("EmployeeList").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.employeeList = []
                    for document in querySnapshot!.documents {
                        var data = document.data()
                        data["document_id"] = document.documentID
                        self.employeeList.append(data)
                        print("\(document.documentID) => \(document.data())")
                    }
                    completion(true)
                }
        }
    }
    
    // listen to data changes and update
    func readDataChanges(completion: @escaping (Bool) -> Void) {
        db.collection("EmployeeList").order(by: "name")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.employeeList = []
                for document in documents {
                    var data = document.data()
                    data["document_id"] = document.documentID
                    self.employeeList.append(data)
                    print("\(document.documentID) => \(document.data())")
                }
                completion(true)
            }
    }
    
    // add data
    func addData(data: [String: Any], completion: @escaping (Bool) -> Void) {
        db.collection("EmployeeList").document().setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                completion(true)
            }
        }
    }
    
    // update data
    func updateData(data: [String: Any], docID: String, completion: @escaping (Bool) -> Void) {
        db.collection("EmployeeList").document(docID).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully updated!")
                completion(true)
            }
        }
    }
    
    // delete document
    func deleteData(docId: String, completion: @escaping (Bool) -> Void) {
        db.collection("EmployeeList").document(docId).delete { err in
            if let err = err {
                print("Error deleting document: \(err)")
            } else {
                print("Document successfully deleted!")
                completion(true)
            }
        }
    }
}
