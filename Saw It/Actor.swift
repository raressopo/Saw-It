//
//  Actor.swift
//  Saw It
//
//  Created by Rares Soponar on 02/06/2018.
//  Copyright © 2018 Rares Soponar. All rights reserved.
//

import UIKit

class Actor: NSObject {
    var name = String()
    var id = Int()
    var character = String()
    var profile = UIImage()
    
    public func initWith(name:String, id:Int, character:String) {
        self.name = name
        self.id = id
        self.character = character
    }
}
