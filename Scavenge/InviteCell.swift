//
//  InviteCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 9/6/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class InviteCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: ProfileImageView!
    @IBOutlet weak var inviteLabel: UILabel!
    @IBOutlet weak var customView: RoundedBorderedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        if (selected) {
//            setSelectedAppearance()
//        } else {
//            setDeselectedAppearance()
//        }
    }
    
    func setSelectedAppearance() {
        customView.backgroundColor = CELL_SELECTED_COLOR
        inviteLabel.text = "invited"
        inviteLabel.textColor = UIColor.lightGray
        self.isUserInteractionEnabled = false
    }
    
    func setDeselectedAppearance() {
        customView.backgroundColor = CELL_DEFAULT_COLOR
        inviteLabel.text = "invite"
        inviteLabel.textColor = UIColor.black
        self.isUserInteractionEnabled = true
    }

}
