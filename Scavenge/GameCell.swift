//
//  GameCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/17/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var roundedBorderView: RoundedBorderedView!
    @IBOutlet weak var gameImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            roundedBorderView.backgroundColor = CELL_HIGHLIGHTED_COLOR
        } else {
            roundedBorderView.backgroundColor = UIColor.white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}

}
