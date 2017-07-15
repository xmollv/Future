//
//  AppDelegate.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataProvider: DataProvider!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        dataProvider = DataProvider()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        checkUserStatus()
        
        return true
    }
    
    private func checkUserStatus() {
        if let _ = UserDefaults.standard.value(forKey: kUserName) {
            let feedViewController = FeedViewController.instantiateFrom(.feed)
            feedViewController.dataProvider = dataProvider
            let navigationController = UINavigationController(rootViewController: feedViewController)
            window?.rootViewController = navigationController
        } else {
            let loginViewController = LoginViewController.instantiateFrom(.login)
            loginViewController.dataProvider = dataProvider
            window?.rootViewController = loginViewController
        }
    }

}

