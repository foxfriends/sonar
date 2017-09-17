//
//  RecommendationsViewModel.swift
//  HTNMusic
//
//  Created by sisi on 2017-09-17.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Bond
import Gloss

class RecommendationsViewModel {
    var recommendations = Array<User>()
    var user: User?
    let sessionManager = SessionManager()
}

extension RecommendationsViewModel {
    func recommend() {
        sessionManager.adapter = AuthRequestAdapter(authToken: (Session.sharedInstance.user?.authToken)!)
        sessionManager.request(UserAPIRouter.suggest((Session.sharedInstance.user?.id)!, (Session.sharedInstance.user?.currentListening)!))
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    if let status: String = "status" <~~ result {
                        if status != "SUCCESS" {
                            print("pp[S")
                        }
                    }
                }
            }
    }
}

extension RecommendationsViewModel {
    func getRecommendations() {
        guard let id = user?.id else { print("no id"); return }
        Alamofire.request(UserAPIRouter.suggestions(id))
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    if let status: String = "status" <~~ result {
                        if status == "SUCCESS" {
                            if let users: [User] = "data" <~~ result {
                                self.recommendations = users
                            }
                        }
                    }
                }
            }
    }
}
