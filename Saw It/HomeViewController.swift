//
//  HomeViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 18/10/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    public var email = String()
    public var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.email)
    }
    
    public func initWithEmail(_ email: String) {
        self.email = email
    }
}
