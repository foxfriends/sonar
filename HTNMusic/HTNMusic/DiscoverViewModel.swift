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
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    self.deserialize(result)
                }
            }
    }
}

extension DiscoverViewModel {
    func updateLocation(coords: Coordinate2D, completion: (Bool) -> Void) {
        Alamofire.request(LocationAPIRouter.location(coord.longitude, coords.latitude))
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    self.deserialize(result)
                }
            }
    }
}

extension DiscoverViewModel {
    func deserialize(result: JSON) {
        guard case APIResult<ProximityInfo>.success(let proximityInfo) = APIResult<ProximityInfo>(json: result)! else {
            print("Cannot de-serialize ProximityInfo")
            return
        }
        self.smallProximityUsers = proximityInfo.close
        self.mediumProximityUsers = proximityInfo.medium
        self.largeProximityUsers = proximityInfo.far
    }
}
