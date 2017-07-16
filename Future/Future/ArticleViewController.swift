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
    @IBOutlet private var articleImageView: RemoteImageView!
    @IBOutlet private var articleScrollView: UIScrollView!
    @IBOutlet private var articleTitleLabel: UILabel!
    @IBOutlet private var articleSubtitleLabel: UILabel!
    @IBOutlet private var articleTextView: UITextView!
    private var favoriteButton: UIBarButtonItem!
    
    //MARK: Class properties
    var dataProvider: DataProvider!
    var articleId: Int!
    private var article: Article?

    //MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(with: nil)
        // Removes the unwanted padding for the UITextView
        articleTextView.textContainerInset = UIEdgeInsets.zero
        articleTextView.textContainer.lineFragmentPadding = 0
        favoriteButton = UIBarButtonItem(image: UIImage(named: "noFavorite"), style: .done, target: self, action: #selector(favoriteButtonTapped(_:)))
        navigationItem.rightBarButtonItem = favoriteButton
        favoriteButton.isEnabled = false
        fetchData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageHeight = articleImageView.bounds.height
        articleScrollView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0)
    }
    
    //MARK: Private methods
    private func fetchData() {
        dataProvider.getSingle(.newsDetails(id: articleId)) { [weak weakSelf = self] (result: Result<Article>) in
            guard let weakSelf = weakSelf else { return }
            switch result {
            case .isSuccess(let article):
                weakSelf.updateUI(with: article)
            case .isFailure(let error):
                FutureError.handle(error: error, onCurrentViewController: weakSelf)
            }
        }
    }
    
    private func updateUI(with article: Article?) {
        self.article = article
        if let article = article {
            if let url = URL(string: article.imageUrl) {
                articleImageView.setRemoteImage(url: url)
            }
            title = article.title
            articleTitleLabel.text = article.title
            articleSubtitleLabel.text = "\(article.source) - \(article.date)"
            articleTextView.text = article.content
            favoriteButton.isEnabled = true
            if favoritedArticles().contains(article.id) {
                favoriteButton.image = UIImage(named: "favorite")
            }
        } else {
            title = ""
            articleTitleLabel.text = ""
            articleSubtitleLabel.text = ""
            articleTextView.text = ""
        }
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        guard let article = article else { return }
        if favoritedArticles().contains(article.id) {
            favoriteButton.image = UIImage(named: "noFavorite")
            removeFavorite(id: article.id)
        } else {
            favoriteButton.image = UIImage(named: "favorite")
            addFavorite(id: article.id)
        }
    }
    
    private func favoritedArticles() -> [Int] {
        return UserDefaults.standard.array(forKey: kFavoritedArticles) as? [Int] ?? []
    }
    
    private func addFavorite(id: Int) {
        var currentFavorites = favoritedArticles()
        currentFavorites.append(id)
        saveFavorites(favorites: currentFavorites)
    }
    
    private func removeFavorite(id: Int) {
        var currentFavorites = favoritedArticles()
        if let index = currentFavorites.index(of: id) {
            currentFavorites.remove(at: index)
        }
        saveFavorites(favorites: currentFavorites)
    }
    
    private func saveFavorites(favorites: [Int]) {
        UserDefaults.standard.set(favorites, forKey: kFavoritedArticles)
    }

}
