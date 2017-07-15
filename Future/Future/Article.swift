//
//  Article.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

struct Article {
    let id: Int
    let title: String
    let imageUrl: String
    let source: String
    let content: String
    let date: String
}

extension Article: JSONInitiable {
    init?(dict: JSONDictionary) {
        guard let id = dict["id"] as? Int,
            let title = dict["title"] as? String,
            let imageUrl = dict["image_url"] as? String,
            let source = dict["source"] as? String,
            let content = dict["content"] as? String,
            let date = dict["date"] as? String else {
                
            Logger.log(message: "Unable to parse the article: \(dict)", event: .error)
            return nil
        }
        
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.source = source
        self.content = content
        self.date = date
    }
}
