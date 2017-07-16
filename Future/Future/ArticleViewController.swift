//
//  ArticleViewController.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet private var articleImageView: UIImageView!
    @IBOutlet private var articleScrollView: UIScrollView!
    @IBOutlet private var articleTitleLabel: UILabel!
    @IBOutlet private var articleSubtitleLabel: UILabel!
    @IBOutlet private var articleTextView: UITextView!
    
    //MARK: Class properties
    var dataProvider: DataProvider!
    var articleId: Int!

    //MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Removes the unwanted padding for the UITextView
        articleTextView.textContainerInset = UIEdgeInsets.zero
        articleTextView.textContainer.lineFragmentPadding = 0
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Used the scrollView to create more of a 'card' style UI leaving the
        // article image on the background when scrolling
        let imageHeight = articleImageView.bounds.height
        articleScrollView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0)
    }
    
    //MARK: Private methods
    private func fetchData() {
        dataProvider.getSingle(.newsDetails(id: articleId)) { (result: Result<Article>) in
            dump(result)
        }
    }

}
