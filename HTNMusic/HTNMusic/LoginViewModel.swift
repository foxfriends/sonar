//
//  LoginViewModel.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Bond
import Gloss

class LoginViewModel {
    let email = Observable<String>("")
    let password = Observable<String>("")
    
    let hasRequestInProgress = Observable<Bool>(false)
    var user: User?
}

extension LoginViewModel {
    func login(success: ((Bool) -> Void)?, failure: @escaping ((String) -> Void)) {
        hasRequestInProgress.value = true
        
        Alamofire.request(LoginAPIRouter.email(email.value, password.value))
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    guard let user = User(json: result) else {
                        print("cannot serialize user")
                        return
                    }
                    
                    self.user = user
                    self.hasRequestInProgress.value = false
                    
                    success?(true)
                } else {
                    self.hasRequestInProgress.value = false
                    failure("Could not log in!")
                }
            }
        
    }
}
