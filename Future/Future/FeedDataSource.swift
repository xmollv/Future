//
//  FeedDataSource.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class FeedDataSource: NSObject, UITableViewDataSource {
    
    //MARK:- Class properties
    private var news: [News]?
    
    //MARK:- Initialization
    override init() {
        super.init()
        news = nil
    }
    
    //MARK:- Public methods
    func replaceCurrentNewsWith(news: [News]) {
        self.news = news
    }
    
    func elementAt(indexPath: IndexPath) -> News? {
        guard let news = news else { return nil }
        if indexPath.row < news.count {
            return news[indexPath.row]
        } else {
            return nil
        }
    }
    
    //MARK:- Data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let newsCount = news?.count else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            tableView.backgroundView = activityIndicator
            tableView.separatorStyle = .none
            return 0
        }
        
        if newsCount == 0 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = "There aren't any news :("
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        
        return newsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let news = news?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: kFeedCell, for: indexPath) as! FeedCell
        cell.configure(with: news)
        return cell
    }
}
