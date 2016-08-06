//
//  PlayingGameTopicCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/31/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class PlayingGameTopicCell: UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var customView: RoundedBorderedView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if (highlighted) {
            customView.backgroundColor = CELL_HIGHLIGHTED_COLOR
        }
        else {
            customView.backgroundColor = CELL_DEFAULT_COLOR
        }
    }
}
