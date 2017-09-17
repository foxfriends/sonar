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
    case profile(String)
    case getSelf()
    case suggest(String, SongInfo)
    case history(String)

    var method: HTTPMethod {
        switch self {
            case .create, .suggest:
                return .post
            case .profile, .getSelf, .history:
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
            case .suggest(_, let song):
                return [
                    "song": song.toJson()
                ]
            case .profile, .getSelf:
                return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
            case .history(let userId):
                let url = URL(string: "\(Constants.loginBaseURL)user/\(userId)/history")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case .create:
                let url = URL(string: "\(Constants.loginBaseURL)user/new")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case .suggest(let userId, _):
                let url = URL(string: "\(Constants.loginBaseURL)user/\(userId)/suggest")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue

                return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
            case .profile(let userId):
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
