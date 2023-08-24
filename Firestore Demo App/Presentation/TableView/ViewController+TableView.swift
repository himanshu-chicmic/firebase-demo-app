//
//  ViewController+TableView.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firestoreManager.getEmployeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableViewCell else {
            fatalError("dequeue error")
        }
        cell.configureCell(data: firestoreManager.getEmployeeList[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EmployeeViewController") as? EmployeeViewController
        vc?.employeeData = firestoreManager.getEmployeeList[indexPath.item]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
