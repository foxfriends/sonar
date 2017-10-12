//
//  User.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

struct User: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let avatarURL: String?
    var likes: Int?
    var currentListening: SongInfo? = nil
    var authToken: String? = nil
    var recentlyPlayed: [SongInfo]?

    init?(json: JSON) {
        guard let id: String = "user_id" <~~ json,
            let firstName: String = "first_name" <~~ json,
            let lastName: String = "last_name" <~~ json,
            let email: String = "email" <~~ json
            else { return nil }

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = "avatar" <~~ json
        self.likes = "likes" <~~ json
        self.email = email
        self.currentListening = "song" <~~ json
        self.authToken = "authtoken" <~~ json
        self.recentlyPlayed = "history" <~~ json
    }
}
