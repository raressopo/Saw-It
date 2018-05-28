//
//  MovieDetailsTableViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 28/05/2018.
//  Copyright © 2018 Rares Soponar. All rights reserved.
//

import UIKit

class MovieDetailsTableViewController: UITableViewController {
    @IBOutlet weak var genreCell: UITableViewCell!
    @IBOutlet weak var lengthCell: UITableViewCell!
    @IBOutlet weak var releaseDateCell: UITableViewCell!
    @IBOutlet weak var actorsCell: UITableViewCell!
    @IBOutlet weak var IMDBRatingCell: UITableViewCell!
    @IBOutlet weak var userRatingCell: UITableViewCell!
    @IBOutlet weak var statusCell: UITableViewCell!
    @IBOutlet weak var pausedMinutesCell: UITableViewCell!
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}
