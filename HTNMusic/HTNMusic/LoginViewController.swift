//
//  FirstViewController.swift
//  HTNMusic
//
//  Created by Yeva Yu on 2017-09-16.
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

        bindViewModel()
    }
}

// MARK: - View Binding

extension LoginViewController {
    func bindViewModel() {
        viewModel.email.bidirectionalBind(to: emailTextField.reactive.text)
        viewModel.password.bidirectionalBind(to: passwordTextField.reactive.text)
        
    }
}

// MARK: - TextField Delegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
            login(nil)
        }
        
        return false
    }
}

// MARK: - IBActions

extension LoginViewController {
    @IBAction func login(_ sender: AnyObject?) {
        viewModel.login(success: { _ in
            if let discoverViewController = UIStoryboard(name: "Discover", bundle: nil).instantiateInitialViewController() as? DiscoverViewController {
                discoverViewController.inject(user: self.viewModel.user!)
                self.present(discoverViewController, animated: true)
            }
        }, failure: { errorMessage in
            let errorAlertController = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            errorAlertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.present(errorAlertController, animated: true, completion: nil)
        })

    }
}

