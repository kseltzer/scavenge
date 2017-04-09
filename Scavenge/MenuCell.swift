//
//  MenuCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 4/9/17.
//  Copyright © 2017 Kim Seltzer. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var pageTitleLabel: UILabel!
    var isCurrentScreen = false
    var menuOption: MenuOption!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if ((selected || isCurrentScreen) && menuOption != .Feedback && menuOption != .Logout) {
            pageTitleLabel.textColor = MENU_OPTION_TEXT_CURRENT_SCREEN_COLOR
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted || isCurrentScreen) {
            pageTitleLabel.textColor = MENU_OPTION_TEXT_CURRENT_SCREEN_COLOR
        } else {
            pageTitleLabel.textColor = MENU_OPTION_TEXT_DEFAULT_COLOR
        }
    }

}
