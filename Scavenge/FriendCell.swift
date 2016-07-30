//
//  FriendCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/22/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

enum CELL_COLOR: String {
    case DEFAULT_COLOR
    case HIGHLIGHTED_COLOR
}

class FriendCell: UITableViewCell {

    @IBOutlet weak var profileImage : ProfileImageView!
    @IBOutlet weak var customView : RoundedBorderedView!
    @IBOutlet weak var nameLabel : UILabel!
    
    var currentBackgroundColor: CELL_COLOR = .DEFAULT_COLOR
    let highlightColor = UIColor.groupTableViewBackgroundColor()
    let defaultColor = UIColor.whiteColor()
    
    var userID : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    func setSelectedAppearance() {
        customView.backgroundColor = highlightColor
    }
    
    func setDeselectedAppearance() {
        customView.backgroundColor = defaultColor
    }

}
