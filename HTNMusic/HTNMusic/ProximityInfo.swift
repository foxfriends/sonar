//
//  ProximityInfo.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

struct ProximityInfo: Decodable {
    var close = Array<User>()
    var medium = Array<User>()
    var far = Array<User>()

    init?(json: JSON) {
        guard let close = "close" <~~ json,
            let medium = "medium" <~~ json,
            let far = "far" <~~ json else {
            return nil
        }
        self.close = close
        self.medium = medium
        self.far = far
    }

    func toJson() -> JSON {
        return [
            "title": self.title,
            "artist": self.artist,
            "album": self.album,
            "id": self.spotifyId as Any
        ]
    }
}
