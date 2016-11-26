//
//  FriendCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/22/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var profileImage : ProfileImageView!
    @IBOutlet weak var customView : RoundedBorderedView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var checkmarkBox: UIImageView!
    
    var userID : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        isSelected = false
    }
    
    func setSelectedAppearance() {
        isSelected = true
        customView.backgroundColor = CELL_SELECTED_COLOR
        checkmarkBox.image = UIImage(named: "checkedBox")
    }
    
    func setDeselectedAppearance() {
        isSelected = false
        customView.backgroundColor = CELL_DEFAULT_COLOR
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
