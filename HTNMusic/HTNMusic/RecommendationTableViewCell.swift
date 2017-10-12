//
//  RecommendationTableViewCell.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit

protocol RecommendationTableViewCellDelegate {
    func recommendationTableViewCell(_: RecommendationTableViewCell, playButtonTappedWith id: String)
}

class RecommendationTableViewCell: UITableViewCell {
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaArtistLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var delegate: RecommendationTableViewCellDelegate?
    var spotifyId: String? = nil
    
    @IBAction func playButtonTapped(_ sender: AnyObject?) {
        guard let id = spotifyId else {
            print("Error: No spotify id")
            return
        }
        
        delegate?.recommendationTableViewCell(self, playButtonTappedWith: id)
    }
}
