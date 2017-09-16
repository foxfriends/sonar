//
//  Coordinate2D.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Gloss

struct Coordinate2D: Decodable {
    let longitude: Double
    let latitude: Double
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init?(json: JSON) {
        guard let longitude: Double = "longitude" <~~ json,
            let latitude: Double = "latitude" <~~ json
            else { return nil }
        
        self.longitude = longitude
        self.latitude = latitude
    }
}
