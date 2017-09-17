//
//  RecommendationTableViewCell.swift
//  HTNMusic
//
//  Created by sisi on 2017-09-17.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit

class RecommendationTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaArtistLabel: UILabel!
    
    var mediaSpotifyId: String? = nil
    weak var delegate: RecommendationTableViewCell?
    
    @IBAction func playSong(_ sender: AnyObject?) {
        guard let spotifyId = self.mediaSpotifyId else { return }
        
        
    }
}
