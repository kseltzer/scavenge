//
//  Constants.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Colors
let COLOR_MINT_GREEN = UIColor(red: 190/255, green: 255/255, blue: 227/255, alpha: 1.0) /* mint green */
let COLOR_PEACH = UIColor(red: 244/255, green: 167/255, blue: 140/255, alpha: 1.0) /* peach */
let COLOR_BROWN = UIColor(red: 236/255, green: 203/255, blue: 140/255, alpha: 1.0) /* orangish-brown */
let COLOR_YELLOW = UIColor(red: 246/255, green: 246/255, blue: 167/255, alpha: 1.0) /* light yellow */
let COLOR_GREEN = UIColor(red: 117/255, green: 221/255, blue: 202/255, alpha: 1.0) /* greenish-blue */

// MARK: - Game Play Constants
let NUM_GAME_QUESTIONS = 5
let IMAGE_RATIO : CGFloat = 8 / 7
let MAX_PLAYERS : Int = 6

// MARK: - Session Constants
let KEY_UID = "uid"
let KEY_FIRST_NAME = "first_name"
let KEY_LAST_NAME = "last_name"

// MARK: - Session Variables
var userProfileImage: UIImage? = nil
var currentUserID: Int!

// MARK: - Storyboard Constants
let kLoginStoryboard = "LoginStoryboard"
let kMainStoryboard = "MainStoryboard"
let kCreateGameStoryboard = "CreateGameStoryboard"
let kPlayingGameStoryboard = "PlayingGameStoryboard"

// MARK: - View Controller Constants
let kLoginViewController = "LoginViewController"
let kHomeViewController = "HomeViewController"
let kCreateGameViewController = "CreateGameViewController"
let kPlayingGameViewController = "PlayingGameViewController"
let kSNavigationController = "SNavigationController"
let kGameResultsViewController = "ResultsViewController"
let kVotingViewController = "VotingViewController"

// MARK: - Segue Constants
let kShowMenuSegue = "showMenu"

// MARK: - Navigation Bar Constants
let NAVIGATION_BAR_TINT_COLOR = UIColor.black
let NAVIGATION_BAR_TEXT_COLOR = UIColor.black
let NAVIGATION_BAR_FONT = UIFont(name: "Avenir-Black", size: 26.0)

// MARK: - Button Constants
let BUTTON_DEFAULT_BACKGROUND_COLOR = COLOR_PEACH
let BUTTON_FACEBOOK_BACKGROUND_COLOR = UIColor(red: 30/255.0, green: 136/255.0, blue: 229/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR_NORMAL = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR_DISABLED = UIColor.lightGray
let BUTTON_TEXT_FONT = UIFont(name: "AvenirNext-Bold", size: 18.0)
let BAR_BUTTON_TEXT_COLOR = UIColor.black

// MARK: - Table View Constants
let TABLE_VIEW_SECTION_FONT = UIFont(name: "AvenirNext-Heavy", size: 22.0)
let TABLE_VIEW_SUBSECTION_FONT = UIFont(name: "AvenirNext-Heavy", size: 16.0)

let VOTING_TABLE_VIEW_SECTION_FONT = UIFont(name: "AvenirNext-Heavy", size: 20.0)
let RESULTS_TABLE_VIEW_SECTION_FONT = UIFont(name: "AvenirNext-Heavy", size: 18.0)
let RESULTS_TABLE_VIEW_SUBSECTION_FONT = UIFont(name: "AvenirNext-Bold", size: 12.0)
let RESULTS_TABLE_VIEW_SECTION_HEIGHT : CGFloat = 28

let kSectionTitleInvites = "INVITES"
let kSectionTitleResults = "RESULTS"
let kSectionTitleActiveGames = "ACTIVE GAMES"
let kSubsectionTitleYourMove = "your move"
let kSubsectionTitleTheirMove = "their move"
let kSectionTitleCompletedGames = "COMPLETED GAMES"

let kSectionTitleRecents = "Recents"
let kSectionTitleFriendsOnScavenge = "Friends"
let kSectionTitleFriendsNotOnScavenge = "Invite"

// MARK: - Menu Customization
let MENU_OPTION_TEXT_DEFAULT_COLOR = UIColor.groupTableViewBackground
let MENU_OPTION_TEXT_CURRENT_SCREEN_COLOR = UIColor.lightGray

// MARK: - Cell Customization
let CELL_COMPLETED_GAME_BACKGROUND_COLOR = UIColor.lightGray
let CELL_ACTIVE_GAME_BACKGROUND_COLOR = UIColor.groupTableViewBackground

let CELL_SELECTED_COLOR = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
let CELL_HIGHLIGHTED_COLOR = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
let CELL_DEFAULT_COLOR = UIColor.white

let kFriendCellIdentifier = "friendCell"

// MARK: - String Constants
let kErrorTitle = "oops!"
let kAcceptFaultErrorMessage = "my bad"

// MARK: - Screen Size Constants
let iPHONE_5: CGFloat = 320.0
let iPHONE_5S: CGFloat = 320.0
let iPHONE_6: CGFloat = 375.0
let iPHONE_6_PLUS: CGFloat = 414.0
let iPHONE_6S: CGFloat = 375.0
let iPHONE_7: CGFloat = 375.0
let iPHONE_7_PLUS: CGFloat = 414.0
let iPHONE_7S: CGFloat = 375.0
let iPHONE_SE: CGFloat = 320.0

// MARK: - JSON Parsing Constants
let JSON_KEY_RECENTS = "recents"
let JSON_KEY_FRIENDS = "friends"
let JSON_KEY_FIRST_NAME = "firstName"
let JSON_KEY_NAME = "name"
let JSON_KEY_PROFILE_IMAGE = "profileImage"
let JSON_KEY_ID = "id"
let JSON_KEY_TITLE = "title"
let JSON_KEY_TOPICS = "topics"

// MARK: - Image Constants
let kNegativeStateProfileImageKim = "negativeStateKim"
let kNegativeStateProfileImageAliya = "negativeStateSachin" // todo, change to "negativeStateAliya"
let kNegativeStateProfileImageMahir = "negativeStateKim" // todo, change to "negativeStateMahir"
let kNegativeStateProfileImageSachin = "negativeStateSachin"
let kNegativeStateProfileImageIan = "negativeStateKim" // todo, change to "negativeStateIan"

let kFlashOnButtonImageName = "flashOnButton"
let kFlashOffButtonImageName = "flashOffButton"
let kFlashAutoButtonImageName = "flashAutoButton"
