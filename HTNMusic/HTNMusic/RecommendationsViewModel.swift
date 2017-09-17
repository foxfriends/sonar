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
    var recommendations = Array<User>();
    var user: User?;
}

extension RecommendationsViewModel {
    func getRecommendations() {
        guard let id = user?.id else { print("no id"); return }
        Alamofire.request(UserAPIRouter.suggestions(id))
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    guard case APIResult<[User]>.success(let recs) = APIResult<[User]>(json: result)! else {
                        print("Could not de-serialize recommendations list")
                        return
                    }
                    self.recommendations = recs;
                }
        }
    }
}
