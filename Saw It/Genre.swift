//
//  Genre.swift
//  Saw It
//
//  Created by Rares Soponar on 17/12/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import Foundation

enum GenreId: Int {
    case Action = 28
    case Adventure = 12
    case Animation = 16
    case Comedy = 35
    case Crime = 80
    case Documentary = 99
    case Drama = 18
    case Family = 10751
    case Fantasy = 14
    case History = 36
    case Horror = 27
    case Music = 10402
    case Mistery = 9648
    case Romance = 10749
    case SF = 878
    case TVMovie = 10770
    case Thriller = 53
    case War = 10752
    case Western = 37
    
    func asString() -> String {
        switch self.rawValue {
        case 28:
            return "Action"
        case 12:
            return "Adventure"
        case 16:
            return "Animation"
        case 35:
            return "Comedy"
        case 80:
            return "Crime"
        case 99:
            return "Documentary"
        case 18:
            return "Drama"
        case 10751:
            return "Family"
        case 14:
            return "Fantasy"
        case 36:
            return "History"
        case 27:
            return "Horror"
        case 10402:
            return "Music"
        case 9648:
            return "Mistery"
        case 10749:
            return "Romance"
        case 878:
            return "SF"
        case 10770:
            return "TV Movie"
        case 53:
            return "Thriller"
        case 10752:
            return "War"
        case 37:
            return "Western"
        default:
            return ""
        }
    }
}

class Genre: NSObject {
    var types = [GenreId(rawValue: 0)]
    var type = GenreId(rawValue: 0)
}
