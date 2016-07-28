//
//  ActiveGameCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class ActiveGameCell: SBaseTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = CELL_ACTIVE_GAME_BACKGROUND_COLOR
    }
}
