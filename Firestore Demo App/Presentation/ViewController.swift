//
//  ViewController.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - properties
    
    let firestoreManager = FirestoreManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        firestoreManager.readDataChanges { complete in
            if complete {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - methods
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc
    func addTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeeViewController") as? AddEmployeeViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

