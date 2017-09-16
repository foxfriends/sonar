//
//  FirstViewController.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class LoginViewController: UIViewController {
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    
    fileprivate var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension LoginViewController {
    func bindViewModel() {
        // todo: FIX THIS LATER
        viewModel.email.bidirectionalBind(to: emailTextField.reactive.text )
        viewModel.password.bidirectionalBind(to: passwordTextField.reactive.text)
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else {
            viewModel.login(success: { _ in
                if let discoverViewController = UIStoryboard(name: "Discover", bundle: nil).instantiateInitialViewController() as? DiscoverViewController {
                    discoverViewController.inject(user: self.viewModel.user!)
                    self.present(discoverViewController, animated: true)
                }
            }, failure: { errorMessage in
                let errorAlertController = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                self.present(errorAlertController, animated: true, completion: nil)
            })
        }
        
        return true
    }
}

