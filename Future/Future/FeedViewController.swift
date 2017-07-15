//
//  FeedViewController.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var tableView: UITableView!
    var logoutButton: UIBarButtonItem!
    
    //MARK: Class properties
    var dataProvider: DataProvider!

    //MARK:- View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = UserDefaults.standard.value(forKey: kUserName) as? String {
            title = "\(name)'s news feed"
        } else {
            fatalError("We should neve reach this state without a name")
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        logoutButton = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logoutButtonTapped(_:)))
        navigationItem.rightBarButtonItem = logoutButton
        
        dataProvider.get(.news) { (result: Result<[Article]>) in
            dump(result)
        }
        
    }
    
    //MARK:- Private methods
    @objc private func logoutButtonTapped(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: kUserName)
        let loginViewController = LoginViewController.instantiateFrom(.login)
        loginViewController.dataProvider = dataProvider
        changeRootViewControllerWithAnimation(currentRoot: self, newRoot: loginViewController)
    }

}
