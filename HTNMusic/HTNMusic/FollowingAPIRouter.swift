//
//  FollowingAPIRouter.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum FollowingAPIRouter: URLRequestConvertible {
    case add(Int)
    case remove(Int)
    case follows(Int)
    case myFollows()
    case followers(Int)
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

    var params: JSON { return [:] }

    func asURLRequest() throws -> URLRequest {
        switch self {
            case .add(let userId), .remove(let userId), .follows(let userId):
                let url = URL(string: "\(Constants.loginBaseURL)follow/\(userId)")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case .myFollows():
                let url = URL(string: "\(Constants.loginBaseURL)follow")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case .myFollowers():
                let url = URL(string: "\(Constants.loginBaseURL)follow/followers")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case .followers(let userId):
                let url = URL(string: "\(Constants.loginBaseURL)follow/followers/\(userId)")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
        }
    }
}
