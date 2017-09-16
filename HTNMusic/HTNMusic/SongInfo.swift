//
//  SongInfo.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

struct SongInfo: Decodable {
    var title: String? = "Unknown Title"
    var artist: String? = "Unknown Artist"
    var spotifyCode: String? = nil

    init?(json: JSON) {
        self.title = "title" <~~ json
        self.artist = "artist" <~~ json
        self.spotifyCode = "spotify_code" <~~ json
    }
}
