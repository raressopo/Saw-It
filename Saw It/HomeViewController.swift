//
//  HomeViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 18/10/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class HomeViewController: UIViewController {
    public var email = String()
    public var userId = String()
    
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func initWithEmail(_ email: String) {
        self.email = email
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        menuView.isHidden = !menuView.isHidden
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        FBSDKAccessToken.setCurrent(nil)
    }
}
