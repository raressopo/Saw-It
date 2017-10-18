//
//  User.swift
//  Saw It
//
//  Created by Rares Soponar on 13/10/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import Foundation

class User {
    var firstName: String? = String()
    var lastName: String? = String()
    var email: String? = String()
    var password: String? = String()
    
    public var users = [User]()
    
    static let sharedInstance = User()
}
