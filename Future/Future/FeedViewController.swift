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
        
        tableView.delegate = self
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
        dataProvider.getMultiple(.news) { [weak weakSelf = self] (result: Result<[News]>) in
            guard let weakSelf = weakSelf else { return }
            switch result {
            case .isSuccess(let news):
                weakSelf.feedDataSource.replaceCurrentNewsWith(news: news)
            case .isFailure(let error):
                 FutureError.handle(error: error, onCurrentViewController: weakSelf)
            }
            weakSelf.tableView.reloadData()
            weakSelf.refreshControl.endRefreshing()
        }
    }
}

//MARK:- UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let news = feedDataSource.elementAt(indexPath: indexPath) {
            let articleViewController = ArticleViewController.instantiateFrom(.article)
            articleViewController.dataProvider = dataProvider
            articleViewController.articleId = news.id
            navigationController?.pushViewController(articleViewController, animated: true)
        } else {
            Logger.log(message: "There isn't any news at the position: \(indexPath.row)", event: .warning)
        }
    }
}
