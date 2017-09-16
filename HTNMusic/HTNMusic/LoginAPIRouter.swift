//
//  LoginAPIRouter.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum LoginAPIRouter: URLRequestConvertible {
    case email(String, String)
    
    var method: HTTPMethod {
        switch self {
            case .email:
                return .post
        }
    }
    
    var params: JSON {
        switch self {
        case .email(let email, let password):
            return [
                "email"    : email,
                "password" : password
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "loginapiurl")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
    }
}
