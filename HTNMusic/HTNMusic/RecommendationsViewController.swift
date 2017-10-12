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
        viewModel.getRecommendations(success: { _ in
            self.tableView.reloadData()
        }, failure: { errorMessage in
            let alertController = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        })
    }
}

// MARK: - Dependency Injection 

extension RecommendationsViewController {
    func inject(user: User) {
        viewModel.user = user
    }
}

// MARK: - IBActions
extension RecommendationsViewController {
    @IBAction func close(_ sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func recommend() {
        self.viewModel.recommend()
    }
}

// MARK: - TableView Datasource

extension RecommendationsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recommendations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendCell") as! RecommendationTableViewCell
        let user: User = viewModel.recommendations[indexPath.row]
        
        cell.mediaTitleLabel.text = user.currentListening?.title
        cell.mediaArtistLabel.text = user.currentListening?.artist
        cell.spotifyId = user.currentListening?.spotifyId
        
        // TODO: Add support for loading an avatar from a url
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

// MARK: - RecommendationTableViewCell Delegate

extension RecommendationsViewController: RecommendationTableViewCellDelegate {
    func recommendationTableViewCell(_: RecommendationTableViewCell, playButtonTappedWith id: String) {
        UIApplication.shared.open(URL(string: "spotify:track:\(id)")!, options: [:], completionHandler: nil)
    }
}
