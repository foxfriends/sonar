//
//  AlamofireHelper.swift
//  HTNMusic
//
//  Created by sisi on 2017-09-17.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation

class Session {
    static let sharedInstance = Session()
    
    var user: User? = nil
    var authToken: String? = nil
}
