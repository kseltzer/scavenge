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
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.image = thumbnailImageView.image?.compress(newSize: CGSize(width: 88, height: 86))
        thumbnailImageView.contentMode = .scaleAspectFit
        
        cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
        cellBackgroundImageView.layer.borderWidth = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            if let backgroundImage = UIImage(named: IMAGE_CELL_BACKGROUND_SELECTED) {
                cellBackgroundImageView.image = backgroundImage
                cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_SELECTED.cgColor
            } else {
                customView.backgroundColor = CELL_HIGHLIGHTED_COLOR
            }
        }
        else {
            if let backgroundImage = UIImage(named: IMAGE_CELL_BACKGROUND) {
                cellBackgroundImageView.image = backgroundImage
                cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
            } else {
                customView.backgroundColor = CELL_DEFAULT_COLOR
            }
        }
    }
}
