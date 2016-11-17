//
//  InviteViaTextCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/16/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class InviteViaTextCell: UITableViewCell {

    @IBOutlet weak var roundedBorderView: RoundedBorderedView!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            roundedBorderView.backgroundColor = CELL_HIGHLIGHTED_COLOR
        } else {
            roundedBorderView.backgroundColor = UIColor(red:0.33, green:0.89, blue:0.42, alpha:1.0)
        }
    }

}
