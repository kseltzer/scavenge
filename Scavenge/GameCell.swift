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
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
        cellBackgroundImageView.layer.borderWidth = 8
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            if let backgroundImage = UIImage(named: IMAGE_CELL_BACKGROUND_SELECTED) {
                cellBackgroundImageView.image = backgroundImage
                cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_SELECTED.cgColor
            } else {
                roundedBorderView.backgroundColor = CELL_HIGHLIGHTED_COLOR
            }
        } else {
            if let backgroundImage = UIImage(named: IMAGE_CELL_BACKGROUND) {
                cellBackgroundImageView.image = backgroundImage
                cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
            } else {
                roundedBorderView.backgroundColor = CELL_DEFAULT_COLOR_HOME
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}

}
