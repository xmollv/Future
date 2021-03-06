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
    @IBOutlet private var loginImageView: RemoteImageView!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet fileprivate var logInButton: UIButton!
    @IBOutlet fileprivate var bottomScrollViewConstraint: NSLayoutConstraint!
    
    //MARK: Class properties
    var dataProvider: DataProvider!
    
    //MARK:- View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged(notification:)),
                                               name: .UIKeyboardWillChangeFrame,
                                               object: nil)
        // Disable the login button until the user types a name
        logInButton.isEnabled = false
        changeButtonBackgroundColor(sender: logInButton)
        loginImageView.setRemoteImage(url: URL(string:kLoginImage)!)
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // The geometry is final here, we can safely round the button
        roundLoginButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.resignFirstResponder()
    }
    
    //MARK:- IBActions
    @IBAction fileprivate func loginTapped(_ sender: UIButton) {
        // Save the username on UserDefaults. It will be used as a token to know
        // if the user is already logged in or not and switch the root view controller
        if let name = nameTextField.text, !name.isEmpty {
            UserDefaults.standard.set(name, forKey: kUserName)
            
            let feedViewController = FeedViewController.instantiateFrom(.feed)
            feedViewController.dataProvider = dataProvider
            let navigationController = UINavigationController(rootViewController: feedViewController)
            changeRootViewControllerWithAnimation(currentRoot: self, newRoot: navigationController)
        }
    }
    
    //MARK:- Private methods
    private func roundLoginButton() {
        let height = logInButton.bounds.height
        logInButton.layer.cornerRadius = height/2
        logInButton.layer.masksToBounds = true
    }
    
    fileprivate func changeButtonBackgroundColor(sender: UIButton) {
        switch sender.state {
        case UIControlState.disabled:
            sender.backgroundColor = UIColor.lightGray
        default:
            sender.backgroundColor = UIColor.darkGray
        }
    }

}

//MARK:- UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let finalText = (text as NSString).replacingCharacters(in: range, with: string).trimmingCharacters(in: .whitespaces)
            if finalText.isEmpty {
                logInButton.isEnabled = false
                changeButtonBackgroundColor(sender: logInButton)
            } else {
                logInButton.isEnabled = true
                changeButtonBackgroundColor(sender: logInButton)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTapped(UIButton())
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- UIKeyboardWillChangeFrame extension
extension LoginViewController {
    @objc fileprivate func keyboardChanged(notification: NSNotification) {
        KeyboardManager.keyboardNotification(notification: notification, constraint: bottomScrollViewConstraint, view: self.view)
    }
}
