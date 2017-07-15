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
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsDateLabel: UILabel!
    @IBOutlet var newsTitleLabel: UILabel!
    @IBOutlet var newsDescriptionLabel: UILabel!
    
    //MARK:- View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6
        layer.masksToBounds = true
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    //MARK: Private methods
    private func clearCell() {
        newsImageView.image = nil
        newsDateLabel.text = nil
        newsTitleLabel.text = nil
        newsDescriptionLabel.text = nil
    }
}
