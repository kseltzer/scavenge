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
    }
    
    override func setSelectedAppearance() {
        super.setSelectedAppearance()
        checkmarkBox.image = UIImage(named: "checkedBox")
    }
    
    override func setDeselectedAppearance() {
        super.setDeselectedAppearance()
        checkmarkBox.image = UIImage(named: "uncheckedBox")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // overridden so users can't touch and drag on cells to unhighlight them
    }

}
