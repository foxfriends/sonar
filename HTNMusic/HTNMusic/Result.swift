//
//  SongInfo.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

// TODO: is this file all made up?

enum Result: Decodable {
    case success(Any)
    case failure(String)

    init?(json: JSON) {
        guard let status = "status" <~~ json else { return failure("Could not parse response") }
        if status == "SUCCESS" {
            return success("data" <~~ json)
        } else if status == "FAILURE" {
            return failure("reason" <~~ json)
        } else {
            return nil
        }
    }
}
