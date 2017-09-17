//
//  RecommendationTableViewCell.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit

protocol WhatTableViewCellDelegate {
    func whatTableViewCell(_: WhatTableViewCell, playButtonTappedWith id: String)
}

class WhatTableViewCell: UITableViewCell {
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaArtistLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var delegate: WhatTableViewCellDelegate?
    var spotifyId: String? = nil
    
    @IBAction func playButtonTapped(_ sender: AnyObject?) {
        guard let id = spotifyId else { return }
        
        delegate?.whatTableViewCell(self, playButtonTappedWith: id)
    }
}
