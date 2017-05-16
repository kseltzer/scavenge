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
    var picture: URL? = nil
    var profileImage: UIImage? = nil // todo: change to URL
    var addedToGame : Bool = false
    var headerIndex : Int? = nil
    var indexPath : IndexPath? = nil
    
    init(id: String, firstName: String, name: String, picture: URL? = nil) {
        self.id = id
        self.firstName = firstName
        self.name = name
        self.picture = picture
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
