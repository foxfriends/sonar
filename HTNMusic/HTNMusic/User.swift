//
//  User.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

struct User: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let avatarURL: String
    var currentListening: SongInfo? = nil
    var authtoken: String? = nil

    init?(json: JSON) {
        guard let id: String = "user_id" <~~ json,
            let firstName: String = "first_name" <~~ json,
            let lastName: String = "last_name" <~~ json,
            let avatarURL: String = "avatar" <~~ json,
            let email: String = "email" <~~ json
            else { return nil }

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = avatarURL
        self.email = email
        self.currentListening = "song" <~~ json
        self.authtoken = "authtoken" <~~ json
    }
}
