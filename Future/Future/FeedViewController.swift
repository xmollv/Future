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
    let feedDataSource = FeedDataSource()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
    }()

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
        
        tableView.dataSource = feedDataSource
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl
        
        fetchData()
    }
    
    //MARK:- Private methods
    @objc private func logoutButtonTapped(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: kUserName)
        let loginViewController = LoginViewController.instantiateFrom(.login)
        loginViewController.dataProvider = dataProvider
        changeRootViewControllerWithAnimation(currentRoot: self, newRoot: loginViewController)
    }
    
    @objc private func fetchData() {
        dataProvider.get(.news) { [weak weakSelf = self] (result: Result<[Article]>) in
            guard let weakSelf = weakSelf else { return }
            switch result {
            case .isSuccess(let articles):
                weakSelf.feedDataSource.replaceCurrentArticlesWith(articles: articles)
            case .isFailure(let error):
                 FutureError.handle(error: error, onCurrentViewController: weakSelf)
            }
            weakSelf.tableView.reloadData()
            weakSelf.refreshControl.endRefreshing()
        }
    }

}
