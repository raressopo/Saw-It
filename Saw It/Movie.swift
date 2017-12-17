//
//  Movie.swift
//  Saw It
//
//  Created by Rares Soponar on 17/12/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var title = String()
    var releaseDate = String()
    var rating = NSNumber()
    var genre = Genre()
    var poster = UIImage()
    
    public var movies = [Movie]()
    
    static let sharedInstance = Movie()
}
