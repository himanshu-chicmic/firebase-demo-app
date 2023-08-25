//
//  ViewController.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import UIKit

class ViewController: UIViewController, EmployeeViewDelegate {

    // MARK: - outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - properties
    
    let firestoreManager = FirestoreManager.shared
    
    var limit: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        firestoreManager.readDataOnChange(limit: limit) { complete in
            if complete {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - methods
    
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }
    
    func reloadTableView() {
        print("reloaded")
        self.tableView.reloadData()
    }
    
    // MARK: - tap actions
    
    @objc
    func addBarButtonTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeeViewController") as? AddEmployeeViewController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

