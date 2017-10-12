//
//  FollowingAPIRouter.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum FollowingAPIRouter: URLRequestConvertible {
    case add(String)
    case remove(String)
    case follows(String)
    case myFollows()
    case followers(String)
    case myFollowers()
    
    var method: HTTPMethod {
      switch self {
          case .add:
              return .put
          case .remove:
              return .delete
          case .follows, .myFollows, .followers, .myFollowers:
              return .get
      }
    }
    
    var urlString: String {
        let baseURL = Constants.sonarBaseURL
        switch self {
            case .add(let userId), .remove(let userId), .follows(let userId):
                return "\(baseURL)follow/\(userId)"
            case .myFollows:
                return "\(baseURL)follow"
            case .myFollowers:
                return "\(baseURL)follow/followers"
            case .followers(let userId):
                return "\(baseURL)follow/followers/\(userId)"
        }
    }
    
    var params: JSON { return [:] }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = method.rawValue

        return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
    }
}
