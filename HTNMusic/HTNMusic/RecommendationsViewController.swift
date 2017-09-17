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
    func inject(user: User) {
        viewModel.user = user
    }
}

extension RecommendationsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recommendations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendationCell") as! RecommendationTableViewCell
        let user: User = viewModel.recommendations[indexPath.row]
        
        cell.mediaTitleLabel.text = user.currentListening?.title
        cell.mediaArtistLabel.text = user.currentListening?.artist
        cell.userImageView.image = UIImage(named: "profile_ic")
        
        return cell
    }
}
