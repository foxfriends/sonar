//
//  DiscoverViewModel.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Bond
import CoreLocation

class DiscoverViewModel {
    var user: User?
    var locationCoordinates: Coordinate2D? = nil
    let isMapViewHidden = Observable<Bool>(true)
    var smallProximityUsers = Array<User>()
    var mediumProximityUsers = Array<User>()
    var largeProximityUsers = Array<User>()
    var userMapCoordinates = Dictionary<String, User>()
}

extension DiscoverViewModel {
    func getNearbyUsers() {
        
        Alamofire.request(NearbyAPIRouter.nearby())
    }
}

extension DiscoverViewModel {
    func updateLocation(coords: Coordinate2D, completion: (Bool) -> Void) {
        
    }
}
