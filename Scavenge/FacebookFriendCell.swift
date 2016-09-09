//
//  FacebookFriendCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/27/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class FacebookFriendCell: FriendCell {

    @IBOutlet weak var inviteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelectedAppearance() {
        super.setSelectedAppearance()
        inviteLabel.text = "invited"
        inviteLabel.textColor = UIColor.lightGrayColor()
        customView.backgroundColor = CELL_HIGHLIGHTED_COLOR
        self.userInteractionEnabled = false
    }
    
    override func setDeselectedAppearance() {
        super.setDeselectedAppearance()
        inviteLabel.text = "invite"
        inviteLabel.textColor = UIColor.blackColor()
        self.userInteractionEnabled = true
    }

}
