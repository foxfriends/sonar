//
//  RecommendationsViewController.swift
//  HTNMusic
//
//  Created by sisi on 2017-09-17.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit

class RecommendationsViewController : UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let viewModel = RecommendationsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        viewModel.getRecommendations(completion: { _ in
            self.tableView.reloadData()
        })
    }
}

extension RecommendationsViewController {
    @IBAction func close(_ sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
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
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "recommendCell") as! WhatTableViewCell
        let user: User = viewModel.recommendations[indexPath.row]
        
        cell2.mediaTitleLabel.text = user.currentListening?.title
        cell2.mediaArtistLabel.text = user.currentListening?.artist
        cell2.spotifyId = user.currentListening?.spotifyId
        
        if user.avatarURL == "avatar1" {
            cell2.userImageView.image = UIImage(named: "blond_hair_guy")!
        } else if user.avatarURL == "avatar2" {
            cell2.userImageView.image = UIImage(named: "black_hair_guy")!
        } else if user.avatarURL == "avatar3" {
            cell2.userImageView.image = UIImage(named: "black_hair_girl")!
        } else {
            cell2.userImageView.image = UIImage(named: "brown_hair_girl")!
        }
        
        cell2.delegate = self

        return cell2
    }
}

extension RecommendationsViewController: WhatTableViewCellDelegate {
    func whatTableViewCell(_: WhatTableViewCell, playButtonTappedWith id: String) {
        UIApplication.shared.open(URL(string: "spotify:track:\(id)")!, options: [:], completionHandler: nil)
    }
}
