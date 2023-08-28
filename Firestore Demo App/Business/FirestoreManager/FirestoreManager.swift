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
    
    private var getDataFirstTime: Bool = true
    
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
    
    // bool to check if any operation on data is performed
    private var processingData: Bool = false
    
    // MARK: - methods
    
    /// method to get data from firestore
    func readDataUpdates(completion: @escaping (Bool) -> Void) {
        let query = db.collection("EmployeeList")
        query.addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if !self.getDataFirstTime && !self.processingData {
                        completion(true)
                    } else {
                        self.getDataFirstTime = false
                        completion(false)
                    }
                }
        }
    }
    
    
    /// method to listen changes in firestore and get data
    /// - Parameters:
    ///   - limit: limit for api response data
    ///   - refreshed: boolean to check if the view is refreshed
    func readDataOnChange(limit: Int, refreshed: Bool = false, completion: @escaping (Bool) -> Void) {
        processingData = true
        var query = db.collection("EmployeeList").limit(to: limit)
        
        // if view is refreshed then don't execute if else block
        if !refreshed {
            if let lastDocumentSnapshot {
                query = query.start(afterDocument: lastDocumentSnapshot)
            } else {
                self.employeeList = []
            }
        }
        
        query
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                // check required conditions for updating data
                if (refreshed || !self.dataEnd) && self.lastDocumentSnapshot != querySnapshot?.documents.last, let querySnapshot {
                    self.lastDocumentSnapshot = querySnapshot.documents.last
                    
                    // if documents.count is less than given limit
                    // set dataEnd = true
                    if documents.count < limit {
                        self.dataEnd = true
                    }
                    
                    // if the view's refreshed set employeeList = []
                    // and set dataEnd = false (in case it's set to true, if all data is already loaded)
                    if refreshed {
                        self.dataEnd = false
                        self.employeeList = []
                    }
                    
                    for document in documents {
                        var data = document.data()
                        data["document_id"] = document.documentID
                        self.employeeList.append(data)
                        print("\(document.documentID) => \(document.data())")
                    }
                    
                    // completion
                    self.processingData = false
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
        processingData = true
        let documentReference = db.collection("EmployeeList").document()
        documentReference.setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                var d = data
                d["document_id"] = documentReference.documentID
                self.employeeList.insert(d, at: 0)
                print("Document successfully written!")
                self.processingData = false
                completion(true)
            }
        }
    }
    
    /// method to update data in firestore
    /// - Parameters:
    ///   - data: data to update
    ///   - docID: id of document
    func updateData(data: [String: Any], docID: String, completion: @escaping (Bool) -> Void) {
        processingData = true
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
                self.processingData = false
                completion(true)
            }
        }
    }
    
    /// method to delete document in firestore
    /// - Parameters:
    ///   - docId: document id
    func deleteData(docId: String, completion: @escaping (Bool) -> Void) {
        processingData = true
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
                self.processingData = false
                completion(true)
            }
        }
    }
}
