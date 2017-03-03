//
//  CustomNavigationBar.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/29/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar, UINavigationBarDelegate {

    override func awakeFromNib() {
        tintColor = NAVIGATION_BAR_TEXT_COLOR
        barTintColor = NAVIGATION_BAR_TINT_COLOR
        titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black,
                               NSFontAttributeName: NAVIGATION_BAR_FONT!]
        delegate = self
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

}
