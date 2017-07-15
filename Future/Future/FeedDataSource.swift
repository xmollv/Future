//
//  FeedDataSource.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class FeedDataSource: NSObject, UITableViewDataSource {
    
    private var articles: [Article]?
    
    override init() {
        super.init()
        articles = nil
    }
    
    func replaceCurrentArticlesWith(articles: [Article]) {
        self.articles = articles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articlesCount = articles?.count else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            tableView.backgroundView = activityIndicator
            return 0
        }
        
        if articlesCount == 0 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = "There aren't any news :("
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
        
        return articlesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let article = articles?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: kFeedCell, for: indexPath) as! FeedCell
        cell.configure(with: article)
        return cell
    }
}
