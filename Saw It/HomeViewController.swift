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
import Firebase

class AddedMovieCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var email = String()
    public var userId = String()
    var moviesRef: DatabaseReference! = nil
    
    @IBOutlet weak var tableView: UITableView!
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
        
        // Get all users from DB and add user after registration
        if let user = User.sharedInstance.currentUser?.email {
            moviesRef = Database.database().reference(withPath: "\(user)")
            if let reference = moviesRef {
                reference.observe(.childAdded, with: { (snapshot) in
                    let singleMovieDict: Dictionary<String, Any> = snapshot.value as! Dictionary<String, Any>
                    let movie = Movie()
                    
                    movie.title = singleMovieDict["title"] as! String
                    movie.rating = singleMovieDict["rating"] as! NSNumber
                    movie.releaseDate = singleMovieDict["releaseDate"] as! String
                    
                    var url = URL.init(string: "")
                    
                    if let posterUrl = singleMovieDict["posterUrl"] {
                        url = URL.init(string: posterUrl as! String)
                    }
                    
                    let receivedData = NSData.init(contentsOf: url!)
                    movie.poster = UIImage.init(data: receivedData! as Data)!
                    
                    let genreIds = singleMovieDict["genreIds"] as! [Int]
                    for genreId in genreIds {
                        movie.genre.types.append(GenreId(rawValue: genreId))
                    }
                    
                    Movie.sharedInstance.movies.append(movie)
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectView.isHidden = true
        self.tableView.reloadData()
    }
    
    public func initWithEmail(_ email: String) {
        self.email = email
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        menuView.isHidden = !menuView.isHidden
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        Movie.sharedInstance.movies = [Movie]()
        FBSDKAccessToken.setCurrent(nil)
    }
    
    @IBAction func addMovieSeriesPressed(_ sender: Any) {
        menuView.isHidden = true
        selectView.isHidden = false
    }
    
    @IBAction func cancelSelectMovieSeriesPressed(_ sender: Any) {
        selectView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Movie.sharedInstance.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addedMovieCell", for: indexPath) as! AddedMovieCell
        let movie = Movie.sharedInstance.movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        
        var rating = "⭐️ "
        var genre = ""
        
        cell.posterImageView.image = movie.poster
        
        for g in movie.genre.types {
            if let gen = g?.asString() {
                genre.append("\(gen),")
            }
        }
        cell.genreLabel.text = genre
        
        rating.append("\(movie.rating)")
        cell.ratingLabel.text = rating
        
        cell.releaseDateLabel.text = movie.releaseDate
        
        cell.titleLabel.sizeToFit()
        
        return cell
    }
    
}
