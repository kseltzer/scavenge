//
//  SNavigationController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class SNavigationController: UINavigationController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.navigationBar.barTintColor = NAVIGATION_BAR_TINT_COLOR
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: NAVIGATION_BAR_TEXT_COLOR, NSFontAttributeName: NAVIGATION_BAR_FONT!]
    }
}

extension UINavigationController {
    /*
     This function replaces the current view controller in the navigation stack with a new view controller but animates like a push
     The back navigation now pops to the root view controller instead of to the current view controller
     */
    func replaceStackWithViewController(destinationViewController: UIViewController) {
        let viewControllers = self.viewControllers
        var newViewControllers : [UIViewController] = []
        newViewControllers.append(viewControllers[0]) // preserve the root view controller
        newViewControllers.append(destinationViewController) // add the new view controller
        self.setViewControllers(newViewControllers, animated: true) // perform the segue
    }
}
