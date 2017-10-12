//
//  DiscoverViewModel.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Bond
import Gloss
import CoreLocation

class DiscoverViewModel {
    var user: User?
    var locationCoordinates: Coordinate2D? = nil
    let isMapViewHidden = Observable<Bool>(false)
    var smallProximityUsers = Array<User>()
    var mediumProximityUsers = Array<User>()
    var largeProximityUsers = Array<User>()
    var userMapCoordinates = Array<ScreenCoords>()
    
    var radarSelectedUser: User? = nil
    var radarPlayId: String? = nil
    
    let sessionManager = SessionManager()
}

extension DiscoverViewModel {
    func getNearbyUsers() {
        sessionManager.request(NearbyAPIRouter.nearby())
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    self.deserialize(result: result)
                }
            }
    }
}

extension DiscoverViewModel {
    func updateLocation(coords: Coordinate2D, completion: @escaping (Bool) -> Void) {
        sessionManager.request(LocationAPIRouter.location(Float(coords.longitude), Float(coords.latitude)))
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    self.deserialize(result: result)
                    completion(true)
                }
            }
    }
}

extension DiscoverViewModel {
    func getUserNearLocation(x: Float, y: Float) -> User? {
        for coord in userMapCoordinates { // Have tolerance of 8px when tapping on a dot
            if abs(Float(coord.x) - x) <= 8 && abs(Float(coord.y) - y) <= 8 {
                return coord.user
            }
        }
        
        return nil
    }
    
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
