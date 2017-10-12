//
//  RecentlyPlayedTableViewCell.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit

protocol RecentlyPlayedTableViewCellDelegate {
    func recentlyPlayedCell(_: RecentlyPlayedTableViewCell, playButtonTappedWith id: String)
}

class RecentlyPlayedTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var spotifyID: String?
    var delegate: RecentlyPlayedTableViewCellDelegate?
    
    @IBAction func playButtonTapped(_ sender: Any) {
        guard let id = self.spotifyID else {
            print("ERROR: No spotify ID")
            return
        }
        
        delegate?.recentlyPlayedCell(self, playButtonTappedWith: id)
    }
}
