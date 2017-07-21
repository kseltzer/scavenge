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
    var picture_url: String? = nil
    var addedToGame : Bool = false
    var headerIndex : Int? = nil
    var indexPath : IndexPath? = nil
    
    init(id: String, firstName: String, name: String, picture_url: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.name = name
        self.picture_url = picture_url
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
