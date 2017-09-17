//
//  SongInfo.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

let noTitle = "Unknown Title"
let noArtist = "Unknown Artist"
let noAlbum = "Unknown Album"

struct SongInfo: Decodable {
    var title: String = noTitle
    var artist: String = noArtist
    var album: String = noAlbum
    var spotifyId: String?

    init(title: String?, artist: String?, album: String?) {
        self.title = title ?? noTitle
        self.artist = artist ?? noArtist
        self.album = album ?? noAlbum
    }

    init?(json: JSON) {
        self.spotifyId = "id" <~~ json
        if let title: String = "title" <~~ json {
          self.title = title
        }
        if let artist: String = "artist" <~~ json {
          self.artist = artist
        }
        if let album: String = "album" <~~ json {
          self.album = album
        }
    }

    func toJson() -> JSON {
        return [
            "title": self.title == noTitle ? nil : self.title,
            "artist": self.artist == noArtist ? nil : self.artist,
            "album": self.album == noAlbum ? nil : self.album,
            "id": self.spotifyId as Any
        ]
    }
}
