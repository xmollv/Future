//
//  LoginViewController.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var logInButton: UIButton!
    @IBOutlet fileprivate var bottomScrollViewConstraint: NSLayoutConstraint!
    
    //MARK:- View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged(notification:)),
                                               name: .UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // The geometry is final here, we can safely round the button
        roundLoginButton()
    }
    
    //MARK:- Private methods
    private func roundLoginButton() {
        let height = logInButton.bounds.height
        logInButton.layer.cornerRadius = height/2
        logInButton.layer.masksToBounds = true
    }

}

//MARK: UIKeyboardWillChangeFrame extension
extension LoginViewController {
    @objc fileprivate func keyboardChanged(notification: NSNotification) {
        KeyboardManager.keyboardNotification(notification: notification, constraint: bottomScrollViewConstraint, view: self.view)
    }
}
