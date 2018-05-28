//
//  Movie.swift
//  Saw It
//
//  Created by Rares Soponar on 17/12/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit

enum MovieStatus: Int {
    case Seen = 1
    case Paused = 2
    case Unseen = 3
}

class Movie: NSObject {
    var title = String()
    var releaseDate = String()
    var rating = NSNumber()
    var genre = Genre()
    var poster = UIImage()
    var movieId = Int()
    
    // These props are for movie details
    var actors = String()
    var length = String()
    var status = MovieStatus(rawValue: 3)
    var minutesPaused = Int()
    var userRating = Double()
    
    public var movies = [Movie]()
    
    static let sharedInstance = Movie()
    
    public func genreAsString() -> String {
        var genre = ""
        
        for g in self.genre.types {
            if let gen = g?.asString() {
                genre.append("\(gen),")
            }
        }
        
        genre.removeLast(1);
        
        return genre
    }
}
