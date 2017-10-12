//
//  UserProfileViewController.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class UserProfileViewController: UIViewController {
    @IBOutlet fileprivate weak var bannerView: UIView!
    @IBOutlet fileprivate weak var userNameLabel: UILabel!
    @IBOutlet fileprivate weak var heartsCountLabel: UILabel!
    @IBOutlet fileprivate weak var userImageView: UIImageView!
    
    @IBOutlet fileprivate weak var recentlyPlayedTableView: UITableView!
    
    fileprivate var viewModel = UserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = viewModel.user {
            userNameLabel.text = "\(user.firstName) \(user.lastName[user.lastName.startIndex])."
            heartsCountLabel.text = "\(user.likes ?? 0)"
            
            // TODO: update to load profiles from a url
            if user.avatarURL == "avatar1" {
                userImageView.image = UIImage(named: "blond_hair_guy")!
            } else if user.avatarURL == "avatar2" {
                userImageView.image = UIImage(named: "black_hair_guy")!
            } else if user.avatarURL == "avatar3" {
                userImageView.image = UIImage(named: "black_hair_girl")!
            } else {
                userImageView.image = UIImage(named: "brown_hair_girl")!
            }
            
            recentlyPlayedTableView.dataSource = self
        } else {
            let alert = UIAlertController(title: "Oops!", message: "No user data found!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Dependency Injection

extension UserProfileViewController {
    func inject(user: User, isSelf: Bool) {
        viewModel.user = user
        viewModel.isSelf = isSelf
    }
}

// MARK: - UITableViewDataSource

extension UserProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentlyPlayed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songInfo = viewModel.recentlyPlayed[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentPlayCell") as! RecentlyPlayedTableViewCell
        
        cell.titleLabel.text = songInfo.title
        cell.artistLabel.text = songInfo.artist
        cell.spotifyID = songInfo.spotifyUrl
        cell.delegate = self
        
        return cell
    }
}

// MARK: - IBActions 

extension UserProfileViewController {
    @IBAction func close(_ sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - RecentlyPlayedTableViewCell Delegate

extension UserProfileViewController: RecentlyPlayedTableViewCellDelegate {
    func recentlyPlayedCell(_: RecentlyPlayedTableViewCell, playButtonTappedWith id: String) {
        UIApplication.shared.open(URL(string: id)!, options: [:], completionHandler: nil)
    }
}
