//
//  ArticleViewController.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    var dataProvider: DataProvider!
    var articleId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        dataProvider.getSingle(.newsDetails(id: articleId)) { (result: Result<Article>) in
            dump(result)
        }
    }

}
