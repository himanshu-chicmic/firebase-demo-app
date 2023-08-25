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
    
    // var to capture last document snapshot for reload
    // paginated data after it
    private var lastDocumentSnapshot: QueryDocumentSnapshot?
    
    // bool value to check the end of data
    private var dataEnd: Bool = false
    
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
                        print("Decoding Error \(error)")
                    }
                }
            }
            return list
        }
    }
    
    private var fetchData: Bool = false
    
    // MARK: - methods
    
    /// method to get data from firestore
    func getData(completion: @escaping (Bool) -> Void) {
        let query = db.collection("EmployeeList")
        query.getDocuments() { (querySnapshot, err) in
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
    
    /// method to listen changes in firestore and get data
    func readDataOnChange(limit: Int, completion: @escaping (Bool) -> Void) {
        
        var query = db.collection("EmployeeList").limit(to: limit)
        
        if let lastDocumentSnapshot {
            query = query.start(afterDocument: lastDocumentSnapshot)
        } else {
            self.employeeList = []
        }
        
        query
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                if !self.fetchData && !self.dataEnd && self.lastDocumentSnapshot != querySnapshot?.documents.last, let querySnapshot {
                    self.lastDocumentSnapshot = querySnapshot.documents.last
                    
                    if documents.count < limit {
                        self.dataEnd = true
                    }
                    
                    for document in documents {
                        var data = document.data()
                        data["document_id"] = document.documentID
                        self.employeeList.append(data)
                        print("\(document.documentID) => \(document.data())")
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }
    
    /// method to add data to firestore
    /// - Parameters:
    ///   - data: data to add
    func addData(data: [String: Any], completion: @escaping (Bool) -> Void) {
        fetchData = true
        let documentReference = db.collection("EmployeeList").document()
        documentReference.setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                var d = data
                d["document_id"] = documentReference.documentID
                self.employeeList.insert(d, at: 0)
                print("Document successfully written!")
                self.fetchData = false
                completion(true)
            }
        }
    }
    
    /// method to update data in firestore
    /// - Parameters:
    ///   - data: data to update
    ///   - docID: id of document
    func updateData(data: [String: Any], docID: String, completion: @escaping (Bool) -> Void) {
        fetchData = true
        db.collection("EmployeeList").document(docID).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                for (index, list) in self.employeeList.enumerated() {
                    if let id = list["document_id"] as? String {
                        if id == docID {
                            self.employeeList[index] = data
                            self.employeeList[index]["document_id"] = docID
                            break
                        }
                    }
                }
                print("Document successfully updated!")
                self.fetchData = false
                completion(true)
            }
        }
    }
    
    /// method to delete document in firestore
    /// - Parameters:
    ///   - docId: document id
    func deleteData(docId: String, completion: @escaping (Bool) -> Void) {
        fetchData = true
        db.collection("EmployeeList").document(docId).delete { err in
            if let err = err {
                print("Error deleting document: \(err)")
            } else {
                for (index, list) in self.employeeList.enumerated() {
                    if let id = list["document_id"] as? String {
                        if id == docId {
                            self.employeeList.remove(at: index)
                            break
                        }
                    }
                }
                print("Document successfully deleted!")
                self.fetchData = false
                completion(true)
            }
        }
    }
}
