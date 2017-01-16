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
    var firstName: String
    var name: String
    var profileImage: UIImage // todo: change to URL
    var addedToGame : Bool = false
    var headerIndex : Int? = nil
    var indexPath : IndexPath? = nil
    
    init(id: Int, firstName: String, name: String, profileImage: UIImage /* todo: change to URL */) {
        self.id = id
        self.firstName = firstName
        self.name = name
        self.profileImage = profileImage
    }
}
