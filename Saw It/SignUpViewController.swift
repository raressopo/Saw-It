//
//  SignUpViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 18/10/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
// MARK: Action methods
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        var newUserDetails = [String:Any]()
        
        if let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text {
            
            if password == confirmPassword {
                newUserDetails = ["email": email, "password": password, "firstName": firstName, "lastName": lastName]
            } else {
                //TODO: Add alert
            }
            
            let ref = Database.database().reference(withPath: "users").child("\(firstName) \(lastName)")
            
            ref.setValue(newUserDetails) { (error: Error?, reference) in
                if error == nil {
                    //TODO: Add alert with succes registration
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
