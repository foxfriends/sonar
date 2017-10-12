//
//  UserAPIRouter.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
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
    case suggestions(String)
    case history(String)

    var method: HTTPMethod {
        switch self {
            case .create, .suggest:
                return .post
            case .profile, .getSelf, .history, .suggestions:
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
                return ["song": song.toJson()]
            case .profile, .getSelf:
                return [:]
            default:
                return [:]
        }
    }
    
    var urlString: String {
        let baseURL = Constants.sonarBaseURL
        switch self {
            case .history(let userId):
                return "\(baseURL)user/\(userId)/history"
            case .create:
                return "\(baseURL)user/new"
            case .suggest(let userId, _):
                return "\(baseURL)user/\(userId)/suggest"
            case .profile(let userId):
                return "\(baseURL)user/\(userId)"
            case .getSelf:
                return "\(baseURL)user"
            case .suggestions(let userId):
                return "\(baseURL)user/\(userId)/suggest"
        }
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(urlRequest, with: params)
    }
}
