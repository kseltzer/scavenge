//
//  Friend.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/29/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

protocol Friend {
    var name : String { get }
    var id : String { get }
    var profileImage : UIImage { get }
}