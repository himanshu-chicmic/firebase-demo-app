//
//  ViewController.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import UIKit

class ViewController: UIViewController, EmployeeViewTableDelegate {

    // MARK: - outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshData: UIButton!
    
    // MARK: - properties
    
    let firestoreManager = FirestoreManager.shared
    
    var limit: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        firestoreManager.readDataOnChange(limit: limit) { complete in
            if complete {
                self.tableView.reloadData()
                self.startListeningDataChangs()
            }
        }
    }
    
    // MARK: - methods
    
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    func startListeningDataChangs() {
        firestoreManager.readDataUpdates { complete in
            print(complete)
            if complete {
                print(complete)
                self.refreshData.isHidden = false
            }
        }
    }
    
    func reloadTableView() {
        print("reloaded")
        self.tableView.reloadData()
    }
    
    // MARK: - tap actions
    
    @objc
    func callPullToRefresh() {
        firestoreManager.readDataOnChange(limit: limit, refreshed: true) { complete in
            if complete {
                self.refreshData.isHidden = true
                self.tableView.reloadData()
            }
            
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc
    func addBarButtonTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeeViewController") as? AddEmployeeViewController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: - ib actions
    
    @IBAction func refreshData(_ sender: Any) {
        tableView.refreshControl?.beginRefreshing()
    }
}

