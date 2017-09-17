//
//  RecommendationTableViewCell.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import UIKit

protocol RecommendationTableViewCellDelegate {
    func recommendationTableViewCell(_: RecommendationTableViewCell, playButtonTappedWith id: String)
}

class RecommendationTableViewCell: UITableViewCell {
    
    var delegate: RecommendationTableViewCellDelegate?
    var spotifyId: String? = nil
    
    @IBAction func playButtonTapped(_ sender: AnyObject?) {
        guard let id = spotifyId else { return }
        
        delegate?.recommendationTableViewCell(self, playButtonTappedWith: id)
    }
}
