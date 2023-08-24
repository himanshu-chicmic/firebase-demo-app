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
    
    var updateData: EmployeeModel?
    
    // MARK: - properties
    
    private let firestoreManager = FirestoreManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        if let data = updateData {
            setTextFieldValues(data: data)
        }
    }
    
    func setTextFieldValues(data: EmployeeModel) {
        nameTextField.text = data.name.capitalized
        teamTextField.text = data.team.uppercased()
        emailTextField.text = data.email
        joinedTextField.text = data.joinedAs.capitalized
        contactTextField.text = data.contact
    }
    
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addTapped))
        navigationItem.title = updateData == nil ? "Add Employee" : "Update Details"
    }
    
    @objc
    func addTapped() {
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
