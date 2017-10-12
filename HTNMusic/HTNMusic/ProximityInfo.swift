//
//  ProximityInfo.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

struct ProximityInfo: Decodable {
    var close = Array<User>()
    var medium = Array<User>()
    var far = Array<User>()

    init?(json: JSON) {
        guard let close: [User] = "close" <~~ json,
            let medium: [User] = "medium" <~~ json,
            let far: [User] = "far" <~~ json else {
            return nil
        }
        self.close = close
        self.medium = medium
        self.far = far
    }
}
