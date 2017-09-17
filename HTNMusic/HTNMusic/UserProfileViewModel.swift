//
//  UserProfileViewModel.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Bond
import Gloss

class UserProfileViewModel {
    var user: User?
    var isSelf: Bool?
    lazy var recentlyPlayed: [SongInfo] = {
        if let recent = self.user?.recentlyPlayed {
            return recent
        } else {
            return []
        }
    }()
}
