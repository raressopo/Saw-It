//
//  User.swift
//  Saw It
//
//  Created by Rares Soponar on 13/10/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import Foundation

class User: NSObject {
    var firstName: String? = String()
    var lastName: String? = String()
    var email: String? = String()
    var password: String? = String()
    var accesToken: String? = String()
    
    public var users = [User]()
    public var currentUser: User?
    
    static let sharedInstance = User()
    
    public func isUserInDB() -> Bool {
        for user: User in User.sharedInstance.users {
            if self.email == user.email && self.password == user.password {
                return true
            }
        }
        
        return false
    }
}
