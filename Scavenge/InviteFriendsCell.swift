//
//  InviteFriendsCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/25/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class InviteFriendsCell: UITableViewCell {

    @IBOutlet weak var roundedBorderView: RoundedBorderedView!
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
        cellBackgroundImageView.layer.borderWidth = 4
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            if let image = UIImage(named: IMAGE_CELL_BACKGROUND_SELECTED) {
                cellBackgroundImageView.image = image
                cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_SELECTED.cgColor
            } else {
                roundedBorderView.backgroundColor = CELL_HIGHLIGHTED_COLOR
            }
        } else {
            if let image = UIImage(named: IMAGE_CELL_BACKGROUND) {
                cellBackgroundImageView.image = image
                cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
            } else {
                roundedBorderView.backgroundColor = UIColor.black
            }
        }
    }

}
