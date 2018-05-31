//
//  MovieDetailsViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 28/05/2018.
//  Copyright © 2018 Rares Soponar. All rights reserved.
//

import UIKit
import Firebase

class MovieDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateTextView: UITextField!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var minutesPausedView: UIView!
    @IBOutlet weak var minutesPausedTextView: UITextField!
    
    var movie = Movie()
    var tableView = MovieDetailsTableViewController()
    var movieLength = NSNumber()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        tableView = self.childViewControllers[0] as! MovieDetailsTableViewController
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        
        statusPicker.delegate = self
        statusPicker.dataSource = self
        
        imageView.image = movie.poster
        movieTitleLabel.text = movie.title
        
        tableView.genreCell.detailTextLabel?.text = movie.genreAsString()
        tableView.IMDBRatingCell.detailTextLabel?.text = movie.rating.stringValue
        tableView.releaseDateCell.detailTextLabel?.text = movie.releaseDate
        
        if movie.userRating != 0 {
            tableView.userRatingCell.detailTextLabel?.text = "\(movie.userRating)"
        }
        
        
        if movie.status!.rawValue >= 0 && movie.status!.rawValue <= 2 {
            tableView.statusCell.detailTextLabel?.text = "\(movie.status!.asString())"
            
            statusPicker.selectRow((movie.status?.rawValue)!, inComponent: 0, animated: false)
        }
        
        tableView.pausedMinutesCell.detailTextLabel?.text = "at \(self.minutesFromIntToString(minutes: movie.minutesPaused)):00"
        
        rateView.layer.borderColor = UIColor.black.cgColor
        rateView.layer.borderWidth = 2
        rateView.layer.cornerRadius = 5
        
        statusPicker.layer.borderColor = UIColor.black.cgColor
        statusPicker.layer.borderWidth = 2
        statusPicker.layer.cornerRadius = 5
        
        minutesPausedView.layer.borderColor = UIColor.black.cgColor
        minutesPausedView.layer.borderWidth = 2
        minutesPausedView.layer.cornerRadius = 5
        
        rateTextView.clearsOnBeginEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getLengthForMovie(id: movie.movieId)
        self.getActorsForMovie(id: movie.movieId)
    }
    
    // MARK: Helper methods
    
    func getLengthForMovie(id: Int) {
        let url = NSURL.init(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=d82d110a851216802c26c3ad4bcf70c2&language=en-US")
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                var movieDetails = jsonObj as! [String:Any]
                
                for detail in movieDetails.keys {
                    if detail.isEqual("runtime") {
                        self.movieLength = movieDetails[detail] as! NSNumber
                    }
                }
                
                OperationQueue.main.addOperation({
                    let hours = self.movieLength.intValue / 60
                    let minutes = self.movieLength.intValue % 60
                    
                    self.tableView.lengthCell.detailTextLabel?.text = "\(hours) hours and \(minutes) minutes"
                    
                    self.tableView.reloadTableView()
                })
            }
        }).resume()
    }
    
    func getActorsForMovie(id: Int) {
        var actors = [String]()
        let url = NSURL.init(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=d82d110a851216802c26c3ad4bcf70c2&language=en-US")
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                let movieCredits = jsonObj!.value(forKey: "cast") as! Array<[String:Any]>
                
                for actor in movieCredits {
                    for info in actor.keys {
                        if info.isEqual("name") {
                            actors.append(actor[info] as! String)
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    self.tableView.actorsCell.detailTextLabel?.text = "\(actors[0]), \(actors[1]), \(actors[2]) etc."
                    
                    self.tableView.reloadTableView()
                })
            }
        }).resume()
    }
    
    func minutesPausedToInt() -> Int {
        let hour = minutesPausedTextView.text?.substring(to: String.Index.init(encodedOffset: 1))
        let minute = minutesPausedTextView.text?.substring(from: String.Index.init(encodedOffset: 2))
        
        let minutesPaused = Int(String(hour!))! * 60 + Int(String(minute!))!
        
        return minutesPaused
    }
    
    func minutesFromIntToString(minutes: Int) -> String {
        let hour = minutes / 60
        let minute = minutes % 60
        let minuteString = String(minute).count == 1 ? "0\(minute)" : "\(minute)"
        
        return "\(hour):\(minuteString)"
    }
    
    // MARK: TableView delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.tableView(tableView, cellForRowAt: indexPath)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            if movie.userRating != 0 {
                rateTextView.text = "\(movie.userRating)"
            }
            
            rateView.isHidden = false
        } else if indexPath.row == 6 {
            statusPicker.isHidden = false;
        } else if indexPath.row == 7 {
            minutesPausedTextView.text = self.minutesFromIntToString(minutes: movie.minutesPaused)
            minutesPausedView.isHidden = false
        }
    }
    
    // MARK: PickerView delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Seen"
        } else if row == 1 {
            return "Paused"
        } else {
            return "Unseen"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let user = User.sharedInstance.currentUser?.email {
            let ref = Database.database().reference(withPath: "\(user)").child("\(movie.title)").child("status")
            
            ref.setValue(row) { (error: Error?, reference) in
                if error == nil {
                    let movieIndex = Movie.sharedInstance.movies.index(of: self.movie)
                    Movie.sharedInstance.movies.remove(at: movieIndex!)
                    
                    self.movie.status = MovieStatus(rawValue: row)
                    Movie.sharedInstance.movies.append(self.movie)
                    
                    self.tableView.statusCell.detailTextLabel?.text = "\(self.movie.status!.asString())"
                    self.statusPicker.isHidden = true
                    
                    if row == 1 {
                        self.minutesPausedView.isHidden = false
                    } else {
                        self.tableView.pausedMinutesCell.detailTextLabel?.text = ""
                        self.tableView.pausedMinutesCell.isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    // MARK: Action methods
    
    @IBAction func saveMinutesPausedPressed(_ sender: Any) {
        if let minPaused = minutesPausedTextView.text {
            let hour = minPaused.substring(to: String.Index.init(encodedOffset: 1))
            let minute = minPaused.substring(from: String.Index.init(encodedOffset: 2))
            
            if minPaused.count != 4 || minPaused[String.Index.init(encodedOffset: 1)] != ":" || (Int(hour) == nil) || (Int(minute) == nil) {
                let alert = UIAlertController(title: "Incorrect time entered", message: "Please enter a valid time (eg. 0:05, 0:40, 1:24, 2:56)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                minutesPausedTextView.text = ""
                
                return
            }
        }
        
        if let user = User.sharedInstance.currentUser?.email {
            let ref = Database.database().reference(withPath: "\(user)").child("\(movie.title)").child("minutesPaused")
            let minutesPaused = self.minutesPausedToInt()
            
            ref.setValue(minutesPaused) { (error: Error?, reference) in
                if error == nil {
                    let movieIndex = Movie.sharedInstance.movies.index(of: self.movie)
                    Movie.sharedInstance.movies.remove(at: movieIndex!)
                    
                    self.movie.minutesPaused = minutesPaused
                    Movie.sharedInstance.movies.append(self.movie)
                    
                    self.tableView.pausedMinutesCell.detailTextLabel?.text = "at \(self.minutesFromIntToString(minutes: minutesPaused)):00"
                    self.minutesPausedView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func rateSavedPressed(_ sender: Any) {
        let rate: String? = rateTextView.text
        
        if let amount = rate {
            if Double(amount) == nil {
                let alert = UIAlertController(title: "Incorrect rate", message: "Please enter a rate that is greater than 1 and smaller than 10", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                rateTextView.text = ""
                
                return
            }
            
            let rateAsDouble = Double(amount)!
            
            if rateAsDouble < 1.0 {
                let alert = UIAlertController(title: "Incorrect rate", message: "Please enter a rate that is greater than 1 and smaller than 10", preferredStyle: .alert)
            
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
                self.present(alert, animated: true, completion: nil)
                rateTextView.text = ""
                
                return
            } else if rateAsDouble > 10.0 {
                let alert = UIAlertController(title: "Incorrect rate", message: "Please enter a rate that is greater than 1 and smaller than 10", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                rateTextView.text = ""
                
                return
            }
            
            if let user = User.sharedInstance.currentUser?.email {
                let ref = Database.database().reference(withPath: "\(user)").child("\(movie.title)").child("userRating")
                
                ref.setValue(rateAsDouble) { (error: Error?, reference) in
                    if error == nil {
                        let movieIndex = Movie.sharedInstance.movies.index(of: self.movie)
                        Movie.sharedInstance.movies.remove(at: movieIndex!)
                        
                        self.movie.userRating = rateAsDouble
                        Movie.sharedInstance.movies.append(self.movie)
                        
                        self.tableView.userRatingCell.detailTextLabel?.text = "\(rateAsDouble)"
                        self.rateView.isHidden = true
                    }
                }
            }
        }
    }
}
