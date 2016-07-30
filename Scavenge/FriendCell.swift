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
    
    var highlightedColor = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
    var selectedColor = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
    let defaultColor = UIColor.whiteColor()
    
    var userID : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    func setSelectedAppearance() {
        customView.backgroundColor = selectedColor
    }
    
    func setDeselectedAppearance() {
        customView.backgroundColor = defaultColor
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if (highlighted) {
            customView.backgroundColor = highlightedColor
        }
    }

}
