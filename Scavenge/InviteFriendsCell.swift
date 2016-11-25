//
//  InviteFriendsCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/25/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class InviteFriendsCell: UITableViewCell {

    @IBOutlet weak var roundedBorderView: RoundedBorderedView!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            roundedBorderView.backgroundColor = CELL_HIGHLIGHTED_COLOR
        } else {
            roundedBorderView.backgroundColor = UIColor.black
        }
    }

}
