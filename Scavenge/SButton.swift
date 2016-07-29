//
//  SButton.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class SButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 3.0
        backgroundColor = BUTTON_DEFAULT_BACKGROUND_COLOR
        titleLabel?.font = BUTTON_TEXT_FONT
        setTitleColor(BUTTON_TEXT_COLOR_NORMAL, forState: .Normal)
        if (state == .Disabled) {
            self.alpha = 0.5
        }
    }
    
}
