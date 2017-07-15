//
//  FeedViewController.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    let logoutButton = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logoutButtonTapped(_:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.rightBarButtonItem = logoutButton
        
        title = "[Name's] news feed"
    }
    
    @objc private func logoutButtonTapped(_ sender: UIBarButtonItem) {
        //FIXME: Missing implementation
        print("logout")
    }

}
