//
//  Constants.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Game Play Constants
let NUM_GAME_QUESTIONS = 5
let IMAGE_RATIO : CGFloat = 8 / 7
let MAX_PLAYERS : Int = 6

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
let kGameResultsViewControllerIdentifier = "ResultsViewController"

// MARK: - Segue Constants
let kShowMenuSegue = "showMenu"

// MARK: - Navigation Bar Constants
let NAVIGATION_BAR_TINT_COLOR = UIColor(red: 108/255, green: 122/255, blue: 137/255, alpha: 1.0)
let NAVIGATION_BAR_TEXT_COLOR = UIColor.whiteColor()
let NAVIGATION_BAR_FONT = UIFont(name: "Helvetica Neue", size: 20.0)

// MARK: - Button Constants
let BUTTON_DEFAULT_BACKGROUND_COLOR = UIColor(red: 244/255.0, green: 81/255.0, blue: 30/255.0, alpha: 1.0)
let BUTTON_FACEBOOK_BACKGROUND_COLOR = UIColor(red: 30/255.0, green: 136/255.0, blue: 229/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR_NORMAL = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR_DISABLED = UIColor.lightGrayColor()
let BUTTON_TEXT_FONT = UIFont(name: "Helvetica Neue", size: 18.0)
let BUTTON_TEXT_FONT_ITALIC = UIFont(name: "HelveticaNeue-Italic ", size: 12.0)
let BAR_BUTTON_TEXT_COLOR = UIColor.whiteColor()

// MARK: - Table View Constants
let TABLE_VIEW_SECTION_FONT = UIFont(name: "HelveticaNeue-Medium", size: 22.0)
let TABLE_VIEW_SUBSECTION_FONT = UIFont(name: "HelveticaNeue-Light", size: 16.0)

let VOTING_TABLE_VIEW_SECTION_FONT = UIFont(name: "HelveticaNeue", size: 20.0)
let RESULTS_TABLE_VIEW_SUBSECTION_FONT = UIFont(name: "HelveticaNeue-Light", size: 12.0)

let kSectionTitleInvites = "Invites"
let kSectionTitleResults = "Results"
let kSectionTitleActiveGames = "Active Games"
let kSubsectionTitleYourMove = "your move"
let kSubsectionTitleTheirMove = "their move"
let kSectionTitleCompletedGames = "Completed Games"

let kSectionTitleRecents = "Recents"
let kSectionTitleFriendsOnScavenge = "Friends On Scavenge"
let kSectionTitleFriendsNotOnScavenge = "Friends Not On Scavenge"

// MARK: - Menu Customization
let MENU_OPTION_TEXT_DEFAULT_COLOR = UIColor.groupTableViewBackgroundColor()
let MENU_OPTION_TEXT_CURRENT_SCREEN_COLOR = UIColor.lightGrayColor()

// MARK: - Cell Customization
let CELL_COMPLETED_GAME_BACKGROUND_COLOR = UIColor.lightGrayColor()
let CELL_ACTIVE_GAME_BACKGROUND_COLOR = UIColor.groupTableViewBackgroundColor()

let CELL_SELECTED_COLOR = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
let CELL_HIGHLIGHTED_COLOR = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
let CELL_DEFAULT_COLOR = UIColor.whiteColor()

let kFriendCellIdentifierScavenge = "scavengeFriendCell"
let kFriendCellIdentifierFacebook = "facebookFriendCell"

// MARK: - String Constants
let kErrorTitle = "oops!"
let kSMSFailureMessage = "SMS services are not available on your device. We tried to help you, but you let us down :/"
let kAcceptFaultErrorMessage = "my bad"