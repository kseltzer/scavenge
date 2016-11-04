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
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if (self.topViewController != nil && self.topViewController!.isKind(of: PlayingGameViewController.self)) {
            self.popToRootViewController(animated: true)
            return nil
        } else {
            return super.popViewController(animated: animated)
        }
    }
}
