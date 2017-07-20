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
        
        // round button
        layer.cornerRadius = 25.0
        
        // set font and colors
        backgroundColor = BUTTON_DEFAULT_BACKGROUND_COLOR
        titleLabel?.font = BUTTON_TEXT_FONT
        setTitleColor(BUTTON_TEXT_COLOR_NORMAL, for: UIControlState())
        if (state == .disabled) {
            self.alpha = 0.5
        }
        
        // add drop shadow
        layer.shadowColor = COLOR_DARK_BROWN.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 2.0
    }
    
}
