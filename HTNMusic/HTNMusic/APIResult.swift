//
//  APIResult.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

enum APIResult<T: Decodable>: Decodable {
    case success(T), failure(String)

    init?(json: JSON) {
        let status: String = "status" <~~ json ?? "FAILURE"
        if status == "SUCCESS" {
            if let t: T = "data" <~~ json {
                self = .success(t)
                return
            }
        } else if status == "FAILURE" {
            self = .failure("reason" <~~ json ?? "")
        }
        self = .failure("Could not parse the result")
    }
}
