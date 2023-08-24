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
    
    @IBOutlet weak var prevPage: UIButton!
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var statckView: UIStackView!
    
    // MARK: - properties
    
    let firestoreManager = FirestoreManager.shared
    
    private var paginationEnabled: Bool = true
    private var limit: Int = 5
    
    private var currentPage: Int = 0 {
        didSet {
            prevPage.isEnabled = (currentPage != 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        if paginationEnabled {
            firestoreManager.getPaginatedData(limit: limit, index: currentPage) { complete, dataCount  in
                if complete {
                    self.tableView.reloadData()
                }
            }
        } else {
            firestoreManager.getData { complete in
                if complete {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - methods
    
    func configureUI() {
        statckView.isHidden = !paginationEnabled
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }
    
    // MARK: - tap actions
    
    @objc
    func addBarButtonTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeeViewController") as? AddEmployeeViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: - actions
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        currentPage -= 1
        firestoreManager.getPaginatedData(limit: limit, index: currentPage) { complete, dataCount in
            if complete {
                self.tableView.reloadData()
                self.nextPage.isEnabled = true
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        currentPage += 1
        firestoreManager.getPaginatedData(limit: limit, index: currentPage) { complete, dataCount in
            if complete {
                self.tableView.reloadData()
                
                if dataCount < self.limit {
                    self.nextPage.isEnabled = false
                }
            } else {
                self.nextPage.isEnabled = false
                self.currentPage -= 1
            }
        }
    }
    
}

