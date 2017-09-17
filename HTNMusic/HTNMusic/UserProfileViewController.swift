//
//  UserProfileViewController.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class UserProfileViewController: UIViewController {
    @IBOutlet fileprivate weak var bannerView: UIView!
    @IBOutlet fileprivate weak var userNameLabel: UILabel!
    @IBOutlet fileprivate weak var heartsCountLabel: UILabel!
    
    @IBOutlet fileprivate weak var recentlyPlayedTableView: UITableView!
    
    fileprivate var viewModel = UserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = viewModel.user {
            userNameLabel.text = "\(user.firstName) \(user.lastName[user.lastName.startIndex]).)"
            
            if let heartsCount = user.likes {
                heartsCountLabel.text = "\(heartsCount)"
            }
            
//            recentlyPlayedTableView.dataSource = self
        } else {
            print("error: no user data")
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

//extension UserProfileViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//}
