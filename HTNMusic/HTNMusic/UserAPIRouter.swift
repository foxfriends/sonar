//
//  UserAPIRouter.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum UserAPIRouter: URLRequestConvertible {
case create(String, String, String, String)
case profile(Int)
case getSelf()
case suggest(Int, SongInfo)

    var method: HTTPMethod {
        switch self {
            case .email, .suggest:
                return .post
            case .profile, .getSelf:
                return .get
        }
    }

    var params: JSON {
        switch self {
            case .create(let firstName, let lastName, let email, let password):
                return [
                    "first" : firstName,
                    "last" : lastName,
                    "psw" : password,
                    "email" : email
                ]
            case .suggest(user_id, song):
                return [
                    "song": song.toJson()
                ]
            case .profile, .getSelf:
                return []
        }
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
            case create():
                let url = URL(string: "\(Constants.loginBaseURL)user/new")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case suggest(userId, _):
                let url = URL(string: "\(Constants.loginBaseURL)user/\(userId)/suggest")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case .profile(userId):
                let url = URL(string: "\(Constants.loginBaseURL)user/\(userId)")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case .getSelf:
                let url = URL(string: "\(Constants.loginBaseURL)user")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
        }
    }
}
