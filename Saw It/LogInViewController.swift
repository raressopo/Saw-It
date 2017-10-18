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

class LogInViewController: UIViewController {
    @IBOutlet weak var loginFBButton: FBSDKLoginButton!
    private var facebookEmail = String()
    
// MARK: - View lifecycle and management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil) {
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
    @IBAction func loginFBButton(_ sender: Any) {
        let login = FBSDKLoginManager();
        
        login.logIn(withReadPermissions: ["email"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if let loginError = error {
                print(loginError);
            } else {
                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result?.token.tokenString, version: nil, httpMethod: "GET")
                _ = req?.start(completionHandler: { (connection, result: Any?, error: Error?) in
                    let dict = result as! Dictionary<String, Any>
                    self.facebookEmail = dict["email"] as! String
                    self.performSegue(withIdentifier: "loginWithFB", sender: self)
                })
            }
        }
    }
}
