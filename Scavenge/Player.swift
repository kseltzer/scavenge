//
//  Player.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 12/23/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

struct Player {
    var id: Int
    var name: String
    var firstName: String = ""
    var profileImage: UIImage? = nil // todo: change to URL
    var addedToGame : Bool = false
    var headerIndex : Int? = nil
    var indexPath : IndexPath? = nil
    
    init(id: Int, firstName: String, name: String, profileImage: UIImage /* todo: change to URL */) {
        self.id = id
        self.firstName = firstName
        self.name = name
        self.profileImage = profileImage
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
