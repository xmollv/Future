//
//  FeedNavigationController.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class FeedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedViewController = FeedViewController.instantiateFrom(.feed)
        setViewControllers([feedViewController], animated: false)
    }

}
