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
    var title: String = "Unknown Title"
    var artist: String = "Unknown Artist"
    var album: String = "Unknown Album"
    var spotfyId: String?

    init?(json: JSON) {
        self.spotifyId = "id" <~~ json
        if let title = "title" <~~ json {
          self.title = title
        }
        if let artist = "artist" <~~ json {
          self.artists = artist
        }
        if let album = "album" <~~ json {
          self.album = album
        }
    }

    func toJson(): JSON {
        return [
            "title": self.title,
            "artist": self.artist,
            "album": self.album,
            "id": self.spotifyId
        ]
    }
}
