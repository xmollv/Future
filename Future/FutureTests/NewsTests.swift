//
//  FutureTests.swift
//  FutureTests
//
//  Created by Xavi Moll on 16/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import XCTest
@testable import Future

class NewsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Init_CorrectJson() {
        let json: JSONDictionary = ["id": 1,
                                    "title": "Test",
                                    "icon_url": "http://localhost.com",
                                    "summary" : "Test summary",
                                    "date" : "16/08/2017"]
        let news = News(dict: json)
        XCTAssertNotNil(news)
    }
    
    func test_Init_MalformedJson() {
        let json: JSONDictionary = ["id": "1",
                                    "title": "Test",
                                    "icon_url": "http://localhost.com",
                                    "summary" : "Test summary",
                                    "date" : "16/08/2017"]
        let news = News(dict: json)
        XCTAssertNil(news)
    }
    
    func test_Init_MissingJsonFields() {
        let json: JSONDictionary = ["id": 1]
        let news = News(dict: json)
        XCTAssertNil(news)
    }
}
