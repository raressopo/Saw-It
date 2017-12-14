//
//  AddMovieViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 12/12/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

import UIKit

class AddMovieVieController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movieTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 1 {
            let searchString = searchText.replacingOccurrences(of: " ", with: "%20")
            let url = NSURL(string: "https://api.themoviedb.org/3/search/movie?api_key=d82d110a851216802c26c3ad4bcf70c2&language=en-US&query=\(searchString)&page=1&include_adult=false")
            
            self.movieTitles = [String]()
            
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    let allMovies = jsonObj!.value(forKey: "results")! as! Array<[String:Any]>
                    
                    for movieDict in allMovies {
                        for key in movieDict.keys {
                            if key.isEqual("original_title") {
                                self.movieTitles.append(movieDict[key] as! String)
                            }
                        }
                    }
                    
                    OperationQueue.main.addOperation({
                        //calling another function after fetching the json
                        //it will show the names to label
                        self.tableView.reloadData()
                    })
                }
            }).resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel?.text = self.movieTitles[indexPath.row]
        return cell
    }
    
}
