//
//  FirestoreManager.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import FirebaseFirestore

class FirestoreManager {
    
    // MARK: - properties
    
    // shared instance of FirestoreManager
    static let shared = FirestoreManager()
    // instance for firestore
    private let db = Firestore.firestore()
    
    // array to store employee list
    private var employeeList: [[String: Any]] = []
    
    private var lastDocumentSnapshot: QuerySnapshot?
    
    private var pagingEnabled: Bool = true
    
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
    
    /// method to get data from firestore
    func getData(completion: @escaping (Bool) -> Void) {
        var query = pagingEnabled ? db.collection("EmployeeList").limit(to: 5) : db.collection("EmployeeList")
        
        if let last = lastDocumentSnapshot?.documents.last {
            query = query.start(afterDocument: last)
        }
        
        query.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.lastDocumentSnapshot = querySnapshot
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
    
    /// method to listen changes in firestore and get data
    func readDataOnChange(completion: @escaping (Bool) -> Void) {
        var query = pagingEnabled ? db.collection("EmployeeList").limit(to: 5) : db.collection("EmployeeList")
        
        if let last = lastDocumentSnapshot?.documents.last {
            query = query.start(afterDocument: last)
        }
        
        query
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.lastDocumentSnapshot = querySnapshot
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
    
    /// method to add data to firestore
    /// - Parameters:
    ///   - data: data to add
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
    
    /// method to update data in firestore
    /// - Parameters:
    ///   - data: data to update
    ///   - docID: id of document
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
    
    /// method to delete document in firestore
    /// - Parameters:
    ///   - docId: document id
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
