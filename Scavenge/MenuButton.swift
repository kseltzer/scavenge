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
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        print("open menu")
    }
}
