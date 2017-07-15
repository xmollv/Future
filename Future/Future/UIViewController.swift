//
//  UIViewController.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    case login
    case feed
    case article
}

extension UIViewController {
    
    // Returns a view controller casted to the correct class completely type safe
    // using the Storyboard enum
    class func instantiateFrom(_ storyboard: Storyboard) -> Self {
        return instantiateFromStoryboardHelper(type: self, storyboardName: storyboard.rawValue.capitalized)
    }
    
    private class func instantiateFromStoryboardHelper<T>(type: T.Type, storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: type.self)) as! T
    }
}

/// This method replaces the current root view controller for a new one
///
/// - Parameters:
///   - currentRoot: This is the current view controller
///   - newRoot: This is the new view controller that will be setted as the root view controller
func changeRootViewControllerWithAnimation(currentRoot: UIViewController, newRoot: UIViewController) {
    guard let _window = UIApplication.shared.delegate?.window else { fatalError("Unable to find the window") }
    guard let window = _window else { fatalError("Unable to find the window") }
    
    let snapshot:UIView = currentRoot.view.snapshotView(afterScreenUpdates: true)!
    newRoot.view.addSubview(snapshot)
    window.rootViewController = newRoot
    
    UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState], animations: {
        snapshot.layer.opacity = 0
    }, completion: { _ in
        snapshot.removeFromSuperview()
    })
}
