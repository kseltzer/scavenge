//
//  InviteViaFacebookCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/16/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class InviteViaFacebookCell: UITableViewCell {

    @IBOutlet weak var roundedBorderView: RoundedBorderedView!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            roundedBorderView.backgroundColor = CELL_HIGHLIGHTED_COLOR
        } else {
            roundedBorderView.backgroundColor = UIColor(red:0.27, green:0.38, blue:0.62, alpha:1.0)
        }
    }

}
