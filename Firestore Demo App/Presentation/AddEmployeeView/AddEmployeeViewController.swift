//
//  AddEmployeeViewController.swift
//  Firestore Demo App
//
//  Created by Himanshu on 8/24/23.
//

import UIKit

class AddEmployeeViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var joinedTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    
    // MARK: - properties
    
    private let firestoreManager = FirestoreManager.shared
    
    var updateData: EmployeeModel?
    
    var delegate: EmployeeViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationItems()
        
        if let data = updateData {
            setTextFieldValues(data: data)
        }
    }
    
    // MARK: - methods
    
    /// method to set data in text fields for update
    /// - Parameter data: EmployeeModel data
    func setTextFieldValues(data: EmployeeModel) {
        nameTextField.text = data.name.capitalized
        teamTextField.text = data.team.uppercased()
        emailTextField.text = data.email
        joinedTextField.text = data.joinedAs.capitalized
        contactTextField.text = data.contact
    }
    
    /// method to setup navigation bar
    func addNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addBarButtonTapped))
        navigationItem.title = updateData == nil ? "Add Employee" : "Update Details"
    }
    
    // MARK: - tap actions
    
    @objc
    func addBarButtonTapped() {
        let employeeModel = EmployeeModel(documentId: "", name: nameTextField.text ?? "", team: teamTextField.text ?? "", email: emailTextField.text ?? "", joinedAs: joinedTextField.text ?? "", contact: contactTextField.text ?? "")
        if let updateData {
            firestoreManager.updateData(data: employeeModel.getDataDictionary(), docID: updateData.documentId) { complete in
                if complete {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            firestoreManager.addData(data: employeeModel.getDataDictionary()) { complete in
                if complete {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
