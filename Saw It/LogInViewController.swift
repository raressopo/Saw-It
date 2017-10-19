//
//  LogInViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 18/10/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginFBButton: FBSDKLoginButton!
    
    var ref = DatabaseReference()
    
    private var facebookEmail = String()
    
// MARK: - View lifecycle and management
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (FBSDKAccessToken.current() != nil) {
            for user in User.sharedInstance.users {
                if user.accesToken == FBSDKAccessToken.current().tokenString {
                    User.sharedInstance.currentUser = user
                }
            }
            
            self.performSegue(withIdentifier: "loginNormal", sender: self)
            // TODO: Treat the case when the user has loged in before on the app
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginWithFB" {
            let nextView = segue.destination as! HomeViewController
            
            nextView.email = facebookEmail
        }
    }

// MARK: - Action methods
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        let user = User()

        if let email = emailTextField.text, let password = passwordTextField.text {
            user.email = email
            user.password = password
        }
        
        if user.isUserInDB() {
            User.sharedInstance.currentUser = user
            self.performSegue(withIdentifier: "loginNormal", sender: self)
        } else {
            //TODO: Add alert in case of failed Log In
        }
    }
    
    @IBAction func loginFBButton(_ sender: Any) {
        let login = FBSDKLoginManager();
        var accesToken = String()
        
        login.logIn(withReadPermissions: ["email"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if let loginError = error {
                print(loginError);
            } else {
                if let token = result?.token.tokenString {
                    accesToken = token
                }
                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,first_name,last_name"], tokenString: result?.token.tokenString, version: nil, httpMethod: "GET")
                _ = req?.start(completionHandler: { (connection, result: Any?, error: Error?) in
                    let dict = result as! Dictionary<String, Any>
                    
                    if let firstName = dict["first_name"], let lastName = dict["last_name"] {
                        self.ref = Database.database().reference(withPath: "users").child("\(firstName) \(lastName)")
                    }
                    
                    let newUserDict = ["email": dict["email"], "firstName": dict["first_name"], "last_name": dict["last_name"], "accesToken": accesToken]
                    self.ref.setValue(newUserDict)
                    
                    self.performSegue(withIdentifier: "loginWithFB", sender: self)
                })
            }
        }
    }
}
