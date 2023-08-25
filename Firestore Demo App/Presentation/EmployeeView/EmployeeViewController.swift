//
//  EmployeeViewController.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import UIKit

class EmployeeViewController: UIViewController {
    
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
    
    var delegate: EmployeeViewDelegate?
    
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
        labelJoinedAs.text?.append(": \(data.joinedAs.capitalized)")
        labelContact.text?.append(": \(data.contact)")
    }
    
    /// method to add button items to navigation item
    func addNavigationItems() {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
        navigationItem.rightBarButtonItems = [trash, edit]
    }
    
    // MARK: - tap actions
    
    @objc
    func editBarButtonTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeeViewController") as? AddEmployeeViewController
        vc?.updateData = employeeData
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc
    func deleteBarButtonTapped() {
        firestoreManager.deleteData(docId: employeeData?.documentId ?? "") { completion in
            if completion {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
