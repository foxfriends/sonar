//
//  DiscoverTableViewCell.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit

protocol DiscoverTableViewCellDelegate {
    func discoverTableViewCell(_: DiscoverTableViewCell, playButtonTappedWith id: String)
}

class DiscoverTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaArtistLabel: UILabel!
    
    var delegate: DiscoverTableViewCellDelegate?
    var spotifyId: String? = nil
    
    @IBAction func playButtonTapped(_ sender: AnyObject?) {
        guard let id = spotifyId else { print("Error: No song ID"); return }
        
        delegate?.discoverTableViewCell(self, playButtonTappedWith: id)
    }
}
