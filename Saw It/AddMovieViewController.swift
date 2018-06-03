//
//  AddMovieViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 12/12/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit
import Firebase

class AddMovieVieController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movieTitles = [String]()
    var movieReleaseDates = [String]()
    var allMovies = [[String:Any]]()
    var movieAdded = false
    
    // MARK: View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    // MARK: Search bar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 1 {
            let searchString = searchText.replacingOccurrences(of: " ", with: "%20")
            let url = NSURL(string: "https://api.themoviedb.org/3/search/movie?api_key=d82d110a851216802c26c3ad4bcf70c2&language=en-US&query=\(searchString)&page=1&include_adult=false")
            
            self.movieTitles = [String]()
            self.movieReleaseDates = [String]()
            
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    self.allMovies = jsonObj!.value(forKey: "results")! as! Array<[String:Any]>
                    
                    for movieDict in self.allMovies {
                        for key in movieDict.keys {
                            if key.isEqual("original_title") {
                                self.movieTitles.append(movieDict[key] as! String)
                            } else if key.isEqual("release_date") {
                                self.movieReleaseDates.append(movieDict[key] as! String)
                            }
                        }
                    }
                    
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
                    })
                }
            }).resume()
        }
    }
    
    // MARK: Table view delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel?.text = self.movieTitles[indexPath.row]
        cell.detailTextLabel?.text = self.movieReleaseDates[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for movieDict in self.allMovies {
            for key in movieDict.keys {
                if key.isEqual("original_title") && (movieDict[key] as! String).isEqual(self.movieTitles[indexPath.row]) && !movieAdded {
                    let movie = Movie()
                    let genreIds: [Int] = movieDict["genre_ids"] as! [Int]
                    
                    movie.title = movieDict["original_title"] as! String
                    movie.releaseDate = movieDict["release_date"] as! String
                    movie.rating = movieDict["vote_average"] as! NSNumber
                    movie.movieId = movieDict["id"] as! Int
                    
                    // Download and add poster
                    var url = URL.init(string: "")
                    
                    if let posterUrl = movieDict["poster_path"] {
                        url = URL.init(string: "http://image.tmdb.org/t/p/w185/\(posterUrl)")
                    }
                    
                    if let user = User.sharedInstance.currentUser?.email {
                        let ref = Database.database().reference(withPath: "\(user)").child("\(movie.title)")
                        
                        if let u = url?.absoluteString {
                            let newMovieDetails = ["title": movie.title, "posterUrl": u, "rating": movie.rating, "releaseDate": movie.releaseDate, "genreIds": genreIds, "id": movie.movieId] as [String : Any]
                            
                            ref.setValue(newMovieDetails) { (error: Error?, reference) in
                                if error == nil {
                                    self.movieAdded = true
                                }
                                
                                return
                            }
                        }
                    }
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
