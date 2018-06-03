//
//  ActorsTableViewController.swift
//  Saw It
//
//  Created by Rares Soponar on 02/06/2018.
//  Copyright © 2018 Rares Soponar. All rights reserved.
//

import UIKit

class ActorCell: UITableViewCell {
    @IBOutlet weak var actorProfileImageView: UIImageView!
    @IBOutlet weak var actorNameCell: UILabel!
    @IBOutlet weak var actorCharacterCell: UILabel!
}

class ActorsTableViewController: UITableViewController {
    var actors = [Actor]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath) as! ActorCell
        let actor = actors[indexPath.row]
        
        cell.actorNameCell.text = actor.name
        cell.actorCharacterCell.text = "as \(actor.character)"
        
        let cgref = actor.profile.cgImage
        let cim = actor.profile.ciImage
        
        if (cgref != nil) || (cim != nil) {
            cell.actorProfileImageView.image = actor.profile
        } else {
            cell.actorProfileImageView.image = UIImage.init(named: "noImage")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123.5
    }
}
