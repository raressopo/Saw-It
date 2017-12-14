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
    @IBOutlet weak var selectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectView.layer.borderColor = UIColor.black.cgColor
        selectView.layer.borderWidth = 2
        selectView.layer.cornerRadius = 5
        
        menuView.layer.borderColor = UIColor.black.cgColor
        menuView.layer.borderWidth = 2
        menuView.layer.cornerRadius = 5
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
    
    @IBAction func addMovieSeriesPressed(_ sender: Any) {
        menuView.isHidden = true
        selectView.isHidden = false
    }
    
    @IBAction func cancelSelectMovieSeriesPressed(_ sender: Any) {
        selectView.isHidden = true
    }
}
