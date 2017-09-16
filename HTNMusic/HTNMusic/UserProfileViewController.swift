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
    fileprivate var viewModel = UserProfileViewModel()
}

extension UserProfileViewController {
    func inject(user: User, isSelf: Bool) {
        viewModel.user = user
        viewModel.isSelf = isSelf
    }
}
