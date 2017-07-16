//
//  LoginViewControllerTests.swift
//  Future
//
//  Created by Xavi Moll on 16/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import XCTest
@testable import Future

class LoginViewControllerTests: XCTestCase {
    
    var loginViewController: LoginViewController!
    
    override func setUp() {
        super.setUp()
        let dataProvider = DataProvider()
        loginViewController = LoginViewController.instantiateFrom(.login)
        loginViewController.dataProvider = dataProvider
        _ = loginViewController.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_dataProviderInitialized() {
        XCTAssertNotNil(loginViewController.dataProvider)
    }
    
}
