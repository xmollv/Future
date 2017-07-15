//
//  News.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

struct News {
    let id: Int
    let title: String
    let iconUrl: String
    let summary: String
    let date: String
}

extension News: JSONInitiable {
    init?(dict: JSONDictionary) {
        guard let id = dict["id"] as? Int,
            let title = dict["title"] as? String,
            let iconUrl = dict["icon_url"] as? String,
            let summary = dict["summary"] as? String,
            let date = dict["date"] as? String else {
                Logger.log(message: "Unable to parse this news: \(dict)", event: .error)
                return nil
        }
        
        self.id = id
        self.title = title
        self.iconUrl = iconUrl
        self.summary = summary
        self.date = date
    }
}
