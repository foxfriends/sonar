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
    
    fileprivate let viewModel = RecommendationsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension RecommendationsViewController {
    @IBAction func mystery() {
        recommend()
    }
    
    func recommend() {
        self.viewModel.recommend()
    }
}

extension RecommendationsViewController {
    func inject(user: User) {
        viewModel.user = user
    }
}

extension RecommendationsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recommendations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendationCell") as! DiscoverTableViewCell
        let user: User = viewModel.recommendations[indexPath.row]
        
        cell.mediaTitleLabel.text = user.currentListening?.title
        cell.mediaArtistLabel.text = user.currentListening?.artist
        
        if user.avatarURL == "avatar1" {
            cell.userImageView.image = UIImage(named: "blond_hair_guy")!
        } else if user.avatarURL == "avatar2" {
            cell.userImageView.image = UIImage(named: "black_hair_guy")!
        } else if user.avatarURL == "avatar3" {
            cell.userImageView.image = UIImage(named: "black_hair_girl")!
        } else {
            cell.userImageView.image = UIImage(named: "brown_hair_girl")!
        }
        
        cell.delegate = self

        return cell
    }
}

extension RecommendationsViewController: DiscoverTableViewCellDelegate {
    func discoverTableViewCell(_: DiscoverTableViewCell, playButtonTappedWith id: String) {
        UIApplication.shared.open(URL(string: "spotify:track:\(id)")!, options: [:], completionHandler: nil)
    }
}
