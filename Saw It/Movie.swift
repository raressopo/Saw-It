//
//  Movie.swift
//  Saw It
//
//  Created by Rares Soponar on 17/12/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit

enum MovieStatus: Int {
    case Seen = 0
    case Paused = 1
    case Unseen = 2
    
    func asString() -> String {
        switch self.rawValue {
        case 0:
            return "Seen"
        case 1:
            return "Paused"
        case 2:
            return "Unseen"
        default:
            return ""
        }
    }
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
    var status = MovieStatus(rawValue: 2)
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
