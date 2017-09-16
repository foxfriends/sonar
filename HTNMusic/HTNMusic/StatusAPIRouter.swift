//
//  StatusAPIRouter.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum StatusAPIRouter: URLRequestConvertible {
    case stop()
    case play(SongInfo)

    var method: HTTPMethod {
        return .put
    }

    var params: JSON {
        switch self {
        case .stop():
            return [
                "status": "STOP"
            ]
        case .play(let song):
            return [
                "status": "PLAY",
                "song": song.toJson()
            ]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Constants.loginBaseURL)status")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
    }
}
