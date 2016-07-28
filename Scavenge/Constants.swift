//
//  Constants.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Session Constants
let KEY_UID = "uid"

// MARK: - Storyboard Constants
let kLoginStoryboard = "LoginStoryboard"
let kMainStoryboard = "MainStoryboard"
let kCreateGameStoryboard = "CreateGameStoryboard"
let kPlayingGameStoryboard = "PlayingGameStoryboard"

// MARK: - View Controller Constants
let kLoginViewController = "LoginViewController"
let kMyScavengesViewController = "MyScavengesViewController"
let kCreateGameViewController = "CreateGameViewController"
let kPlayingGameViewController = "PlayingGameViewController"
let kSNavigationController = "SNavigationController"

// MARK: - Navigation Bar Constants
let NAVIGATION_BAR_TINT_COLOR = UIColor.lightGrayColor() // UIColor(red: 30/255.0, green: 136/255.0, blue: 229/255.0, alpha: 1.0)
let NAVIGATION_BAR_TEXT_COLOR = UIColor.whiteColor()
let NAVIGATION_BAR_FONT = UIFont(name: "Helvetica Neue", size: 24.0)
let BACK_BAR_BUTTON = UIImage()
let BACK_BAR_BUTTON_MASK = UIImage()

// MARK: - Button Constants
let BUTTON_DEFAULT_BACKGROUND_COLOR = UIColor(red: 244/255.0, green: 81/255.0, blue: 30/255.0, alpha: 1.0)
let BUTTON_FACEBOOK_BACKGROUND_COLOR = UIColor(red: 30/255.0, green: 136/255.0, blue: 229/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
let BUTTON_TEXT_FONT = UIFont(name: "Helvetica Neue", size: 18.0)
let BUTTON_TEXT_FONT_ITALIC = UIFont(name: "HelveticaNeue-Italic ", size: 12.0)
let BAR_BUTTON_TEXT_COLOR = UIColor.whiteColor()

// MARK: - Table View Constants
let CELL_COMPLETED_GAME_BACKGROUND_COLOR = UIColor.lightGrayColor()
let CELL_ACTIVE_GAME_BACKGROUND_COLOR = UIColor.greenColor()
let CELL_SELECTED_COLOR = UIColor.groupTableViewBackgroundColor()
let kSectionTitleRecents = "Recents"
let kSectionTitleFriendsOnScavenge = "Friends On Scavenge"
let kSectionTitleFriendsNotOnScavenge = "Friends Not On Scavenge"

// MARK: - String Constants
let kErrorTitle = "Uh Oh!"
let kSMSFailureMessage = "SMS services are not available on your device. We tried to help you, but you let us down :/"
let kAcceptFaultErrorMessage = "my bad"

// MARK: - Cell Customization
let kFriendCellIdentifierScavenge = "scavengeFriendCell"
let kFriendCellIdentifierFacebook = "facebookFriendCell"