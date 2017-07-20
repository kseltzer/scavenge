//
//  FriendCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/22/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

//    @IBOutlet weak var profileImage : ProfileImageView!
    
    @IBOutlet weak var profileImage: NetworkImageView!
    @IBOutlet weak var customView : RoundedBorderedView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var checkmarkBox: UIImageView!
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    
    
    var userID : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        isSelected = false
        
        cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
        cellBackgroundImageView.layer.borderWidth = 4
    }
    
    func setSelectedAppearance() {
        isSelected = true
        if let backgroundImage = UIImage(named: "cellBackgroundChecked") {
            cellBackgroundImageView.image = backgroundImage
        } else {
            customView.backgroundColor = CELL_SELECTED_COLOR
        }
        cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_SELECTED.cgColor
        checkmarkBox.image = UIImage(named: "checkedBox")
    }
    
    func setDeselectedAppearance() {
        isSelected = false
        if let backgroundImage = UIImage(named: "cellBackground") {
            cellBackgroundImageView.image = backgroundImage
        } else {
            customView.backgroundColor = CELL_DEFAULT_COLOR
        }
        cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
        checkmarkBox.image = UIImage(named: "uncheckedBox")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        if (highlighted) {
//            customView.backgroundColor = CELL_HIGHLIGHTED_COLOR
//        }
//        else if !isSelected {
//            customView.backgroundColor = CELL_DEFAULT_COLOR
//        }
    }
}
