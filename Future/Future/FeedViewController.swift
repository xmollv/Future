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
    let logoutButton = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logoutButtonTapped(_:)))
    
    //MARK: Class properties
    var dataProvider: DataProvider!

    //MARK:- View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FIXME: Create a UIColor extension to hold every color used in the app
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.rightBarButtonItem = logoutButton
        
        title = "[Name's] news feed"
        
        dataProvider.get(.news) { (result: Result<[Article]>) in
            dump(result)
        }
        
    }
    
    //MARK:- Private methods
    @objc private func logoutButtonTapped(_ sender: UIBarButtonItem) {
        //FIXME: Missing implementation
        print("logout")
    }

}
