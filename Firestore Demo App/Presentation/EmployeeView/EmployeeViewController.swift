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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        // update labels data on viewDidLoad()
        updateData()
    }
    
    // MARK: - methods
    
    func updateData() {
        guard let data = employeeData else {
            return
        }
        
        labelName.text = data.name.capitalized
        labelTeam.text = data.team.uppercased()
        labelEmail.text = data.email
        labelJoinedAs.text?.append(": \(data.joinedAs.capitalized)")
        labelContact.text?.append(": \(data.contact)")
    }
    
    func configureUI() {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(addTapped))
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
        
        navigationItem.rightBarButtonItems = [trash, edit]
    }
    
    @objc
    func addTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeeViewController") as? AddEmployeeViewController
        vc?.updateData = employeeData
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc
    func deleteTapped() {
        firestoreManager.deleteData(docId: employeeData?.documentId ?? "") { completion in
            if completion {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
