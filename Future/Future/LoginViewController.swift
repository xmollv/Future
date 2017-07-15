//
//  LoginViewController.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var logInButton: UIButton!
    @IBOutlet fileprivate var bottomScrollViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged(notification:)),
                                               name: .UIKeyboardWillChangeFrame,
                                               object: nil)
    }

}

extension LoginViewController {
    @objc fileprivate func keyboardChanged(notification: NSNotification) {
        KeyboardManager.keyboardNotification(notification: notification, constraint: bottomScrollViewConstraint, view: self.view)
    }
}
