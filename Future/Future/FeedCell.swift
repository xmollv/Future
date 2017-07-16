//
//  FeedCell.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

class FeedCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet private var newsImageView: RemoteImageView!
    @IBOutlet private var newsDateLabel: UILabel!
    @IBOutlet private var newsTitleLabel: UILabel!
    @IBOutlet private var newsDescriptionLabel: UILabel!
    
    //MARK:- View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 6
        newsImageView.layer.masksToBounds = true
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    //MARK:- Private methods
    private func clearCell() {
        newsImageView.image = nil
        newsDateLabel.text = nil
        newsTitleLabel.text = nil
        newsDescriptionLabel.text = nil
    }
    
    //MARK:- Public methods
    func configure(with news: News) {
        if let url = URL(string: news.iconUrl) {
            newsImageView.sd_setImage(with: url)
        }
        newsDateLabel.text = news.date
        newsTitleLabel.text = news.title
        newsDescriptionLabel.text = news.summary
    }
}
