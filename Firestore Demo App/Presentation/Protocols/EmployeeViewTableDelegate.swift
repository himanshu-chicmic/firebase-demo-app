//
//  EmployeeViewDelegate.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/25/23.
//

import Foundation


protocol EmployeeViewTableDelegate {
    func reloadTableView()
}

protocol EmployeeViewDataDelegate {
    func reloadData(data: EmployeeModel)
}
