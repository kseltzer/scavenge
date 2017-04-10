//
//  MenuButton.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/29/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class MenuButton: UIBarButtonItem {

    override func awakeFromNib() {
        title = "Menu"
        setTitleTextAttributes([NSForegroundColorAttributeName: COLOR_DARK_BROWN, NSFontAttributeName: BUTTON_TEXT_FONT!], for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        print("open menu")
    }
}
