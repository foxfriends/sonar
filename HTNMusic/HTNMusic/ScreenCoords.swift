//
//  ScreenCoords.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation

struct ScreenCoords {
    var x: Int
    var y: Int
    var user: User
    
    init(x: Int, y: Int, user: User) {
        self.x = x
        self.y = y
        self.user = user
    }
}
