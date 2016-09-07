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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
