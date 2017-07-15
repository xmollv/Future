//
//  KeyboardManager.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

struct KeyboardManager {
    
    /// This method handles the notifications posted by the system when the keyboard appears on screen or
    /// changes it's size
    /// ````
    /// StackOverflow: http://stackoverflow.com/a/27135992/5683397
    /// ````
    ///
    /// - Parameters:
    ///   - notification: The NSNotification posted by the system
    ///   - constraint: The constraint that will be modified when the notification arrives
    ///   - view: The view where where the view that presented the keyboard lives. Currently tested only using UIViewController.view (self.view from the call site)
    ///   - defaultConstraintValue: The default value of the consstraint before being changed
    static func keyboardNotification(notification: NSNotification, constraint: NSLayoutConstraint, view: UIView, defaultConstraintValue: CGFloat = 0.0) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                constraint.constant = defaultConstraintValue
            } else {
                constraint.constant = endFrame!.size.height + defaultConstraintValue
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: animationCurve, animations: {
                view.layoutIfNeeded()
            },completion: nil)
        }
    }
}
