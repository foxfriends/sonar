//
//  NearbyAPIRouter.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum NearbyAPIRouter: URLRequestConvertible {
    case nearby()

    var method: HTTPMethod {
        return .get
    }

    var params: JSON {
        switch self {
        case .nearby():
            return []
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Constants.loginBaseURL)nearby")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
    }
}
