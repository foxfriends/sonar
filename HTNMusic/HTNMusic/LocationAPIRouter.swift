//
//  LocationAPIRouter.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum LocationAPIRouter: URLRequestConvertible {
    case location(Float, Float)

    var method: HTTPMethod {
        return .put
    }

    var params: JSON {
        switch self {
        case .location(let longitude, let latitude):
            return [
                "lng" : longitude,
                "lat" : latitude
            ]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Constants.loginBaseURL)location")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
    }
}
