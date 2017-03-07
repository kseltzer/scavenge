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
        thumbnailImageView.image = thumbnailImageView.image?.compress(newSize: CGSize(width: 88, height: 86))
        thumbnailImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            customView.backgroundColor = CELL_HIGHLIGHTED_COLOR
        }
        else {
            customView.backgroundColor = CELL_DEFAULT_COLOR
        }
    }
}
