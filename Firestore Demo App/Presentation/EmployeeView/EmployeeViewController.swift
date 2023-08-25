//
//  EmployeeViewController.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import UIKit

class EmployeeViewController: UIViewController, EmployeeViewDataDelegate {
    
    // MARK: - outlets
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTeam: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelJoinedAs: UILabel!
    @IBOutlet weak var labelContact: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - properties
    
    var employeeData: EmployeeModel?
    
    private let firestoreManager = FirestoreManager.shared
    
    var delegate: EmployeeViewTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationItems()
        setLabelsText()
    }
    
    // MARK: - methods
    
    /// method to set/update data in labels
    func setLabelsText() {
        guard let data = employeeData else {
            return
        }
        
        labelName.text = data.name.capitalized
        labelTeam.text = data.team.uppercased()
        labelEmail.text = data.email
        labelJoinedAs.text = "Joined as: \(data.joinedAs.capitalized)"
        labelContact.text = "Contact: \(data.contact)"
    }
    
    /// method to add button items to navigation item
    func addNavigationItems() {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
        navigationItem.rightBarButtonItems = [trash, edit]
    }
    
    func reloadData(data: EmployeeModel) {
        employeeData = data
        setLabelsText()
    }
    
    // MARK: - tap actions
    
    @objc
    func editBarButtonTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeeViewController") as? AddEmployeeViewController
        vc?.delegate = delegate
        vc?.dataSource = self
        vc?.updateData = employeeData
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc
    func deleteBarButtonTapped() {
        firestoreManager.deleteData(docId: employeeData?.documentId ?? "") { completion in
            if completion {
                self.delegate?.reloadTableView()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
