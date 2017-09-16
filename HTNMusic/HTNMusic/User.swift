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
    let id: String
    let firstName: String
    let lastName: String
    let avatarURL: String
    var currentListening: SongInfo? = nil
    var authToken: String? = nil
    
    init?(json: JSON) {
        guard let id: String = "user_id" <~~ json,
            let firstName: String = "first_name" <~~ json,
            let lastName: String = "last_name" <~~ json,
            let avatarURL: String = "avatar_url" <~~ json
            else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = avatarURL
        self.currentListening = "song_info" <~~ json
        self.authToken = "auth_token" <~~ json
    }
}
