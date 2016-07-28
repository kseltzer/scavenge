//
//  SBaseTableViewCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class SBaseTableViewCell: UITableViewCell {

    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameStatusImage: UIImageView?
    @IBOutlet weak var gameStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        gameStatusImage?.layer.cornerRadius = 2.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
