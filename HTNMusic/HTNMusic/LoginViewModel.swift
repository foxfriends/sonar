//
//  LoginViewModel.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import Foundation
import Alamofire
import Bond
import Gloss

class LoginViewModel {
    let email = Observable<String?>("")
    let password = Observable<String?>("")
    
    let hasRequestInProgress = Observable<Bool>(false)
    var user: User?
}

extension LoginViewModel {
    func login(success: ((Bool) -> Void)?, failure: @escaping ((String) -> Void)) {
        hasRequestInProgress.value = true
        
        guard let email = email.value,
            let password = password.value
            else { print("empty email/password"); return }
        
        Alamofire.request(LoginAPIRouter.email(email, password))
            .responseJSON { response in
                if let result = response.result.value as? JSON {
                    // Ideally, we would just use the .validate() function and status codes to convey failure/success
                    guard case APIResult<User>.success(let user) = APIResult<User>(json: result)! else {
                        self.hasRequestInProgress.value = false
                        failure("Could not verify user, please try again!")
                        return
                    }

                    self.user = user
                    Session.sharedInstance.user = user
                    Session.sharedInstance.authToken = user.authToken!
                    
                    let sessionManager = SessionManager()
                    sessionManager.adapter = AuthRequestAdapter(authToken: user.authToken!)
                    
                    self.hasRequestInProgress.value = false
                    success?(true)
                } else {
                    self.hasRequestInProgress.value = false
                    failure("Something went wrong, please try again!")
                }
            }
        
    }
}
