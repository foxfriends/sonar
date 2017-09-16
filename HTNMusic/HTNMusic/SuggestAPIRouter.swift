//
//  SuggestAPIRouter.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum NearbyAPIRouter: URLRequestConvertible {
    case suggest(Int, SongInfo)

    var method: HTTPMethod {
        return .post
    }

    var params: JSON {
        case .suggest(user_id, song):
            return [
                "song": song.toJson()
            ]
        }
    }

    func asURLRequest() throws -> URLRequest {
        case .suggest(user_id, _):
            let url = URL(string: "\(Constants.loginBaseURL)\(user_id)/suggest")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
        }
    }
}
