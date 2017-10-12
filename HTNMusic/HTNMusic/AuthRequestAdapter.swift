//
//  AuthRequestAdapter.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-17.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire

class AuthRequestAdapter: RequestAdapter {
    private let authToken: String
    
    init(authToken: String) {
        self.authToken = authToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}
