//
//  SBarButtonItem.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class SBarButtonItem: UIBarButtonItem {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = BAR_BUTTON_TEXT_COLOR
        setTitleTextAttributes([NSFontAttributeName:BUTTON_TEXT_FONT!], for: UIControlState())
    }
}
