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
    var id: String
    var name: String
    var firstName: String = ""
    var profileImage: UIImage? = nil // todo: change to URL
    var addedToGame : Bool = false
    var headerIndex : Int? = nil
    var indexPath : IndexPath? = nil
    
    init(id: String, firstName: String, name: String, profileImage: UIImage /* todo: change to URL */) {
        self.id = id
        self.firstName = firstName
        self.name = name
        self.profileImage = profileImage
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
