//
//  APIResult.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

enum APIResult<T>: Decodable {
    case success(T), failure(String)

    init?(json: JSON) {
        let status: String = "status" <~~ json ?? "FAILURE"
        if status == "SUCCESS" {
            self = .success(("data" <~~ json)!)
        } else if status == "FAILURE" {
            self = .failure("reason" <~~ json ?? "")
        } else {
            self = .failure("Could not parse the result")
        }
    }
}
