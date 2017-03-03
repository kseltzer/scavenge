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
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        gameImageView!.layer.cornerRadius =  gameImageView!.frame.size.height * 3/4
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            roundedBorderView.backgroundColor = CELL_HIGHLIGHTED_COLOR
        } else {
            roundedBorderView.backgroundColor = CELL_DEFAULT_COLOR_HOME
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}

}
