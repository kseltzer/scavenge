//
//  ScavengeFriendCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/27/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class ScavengeFriendCell: FriendCell {
    
    @IBOutlet weak var checkmarkBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelectedAppearance() {
        super.setSelectedAppearance()
        checkmarkBox.image = UIImage(named: "checkedBox")
    }
    
    override func setDeselectedAppearance() {
        super.setDeselectedAppearance()
        checkmarkBox.image = UIImage(named: "uncheckedBox")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
