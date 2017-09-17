//
//  RecommendationsViewController.swift
//  HTNMusic
//
//  Created by sisi on 2017-09-17.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit

class RecommendationsViewController : UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension RecommendationsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendationCell") as! RecommendationTableViewCell
        let songInfo: SongInfo
        
        
        
        cell.mediaTitleLabel.text = songInfo?.title
        cell.mediaArtistLabel.text = songInfo?.artist
        cell.userImageView.image = UIImage(named: "profile_ic")
        
        return cell
    }
}
